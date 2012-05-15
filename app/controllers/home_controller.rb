class HomeController < ApplicationController

  respond_to :html, :xml, :json

  def home
  	@import = Import.new
  end

  def about
  end

  def account
    if current_user
      @user = current_user
    else
      flash[:notice] = "You must be logged in."
      redirect_to dashboard_url
    end

    @usage_point = @user.usage_point
  end

  def update_account
    if current_user
      @user = current_user
    else
      flash[:notice] = "You must be logged in."
      redirect_to dashboard_url
    end

    @usage_point = @user.usage_point

    if @usage_point.update_attributes(params[:usage_point])
      flash[:notice] = "Account successfully updated!"
      
      if not params[:next].blank?
        redirect_to params[:next]
      else
        redirect_to dashboard_url
      end
    else
      render 'account'
    end

  end


  def dashboard

    if not session['usage-point'].blank?
      if user_signed_in?
        @usage_point = current_user.usage_point = UsagePoint.find_by_id(session['usage-point'])
        current_user.save!()
        session.delete 'usage-point'
      else
        puts "Usage Point!"
        @usage_point = UsagePoint.find_by_id(session['usage-point'])
      end
    elsif user_signed_in? && current_user.usage_point
      puts "Logged-in!"
      @usage_point = current_user.usage_point
    else
      puts "Redirect!"
      return redirect_to :controller => :imports, :action => :new
    end

  	@settings = {}
  	@settings[:timeframe] = params[:timeframe]

    all_readings = @usage_point.readings
    generate_chart(all_readings, "year, month")

  	respond_to do |format|
  		format.html {}
  		format.js   { render :partial => 'dashboard', :status => :ok }
  	end
  end

  def go_solar
    if not session['usage-point'].blank?
      if user_signed_in?
        @usage_point = current_user.usage_point = UsagePoint.find_by_id(session['usage-point'])
        current_user.save!()
        session.delete 'usage-point'
      else
        puts "Usage Point!"
        @usage_point = UsagePoint.find_by_id(session['usage-point'])
      end
    elsif user_signed_in? && current_user.usage_point
      puts "Logged-in!"
      @usage_point = current_user.usage_point
    else
      puts "Redirect!"
      return redirect_to :controller => :imports, :action => :new
    end

    @zipcode = Zipcode.find(:first, :conditions => {:zipcode => @usage_point.zip_code})

    @solar_insolation_data = SolarInsolationGrid.containing_latlon(@zipcode.latitude, @zipcode.longitude)[0]

    @geom = @solar_insolation_data.the_geom.to_s
    @geom_geographic = "Geographic: #{@solar_insolation_data.geom_unproject}"
    @lat = @zipcode.latitude
    @lon = @zipcode.longitude

    @panel_factor = 1

    @usage_data = @usage_point.readings.select('EXTRACT(year from start) as year, EXTRACT(month from start) as month, SUM(value)/1000 as total_usage').group('year, month').collect{|entry| [entry.month, entry.total_usage]}

    tmp_hash = {}

    for entry in @usage_data
      if tmp_hash[entry[0]]
        tmp_hash[entry[0]] = [tmp_hash[entry[0]][0] + entry[1].to_i, tmp_hash[entry[0]][1] + 1]
      else
        tmp_hash[entry[0]] = [entry[1].to_i, 1]
      end
    end

    annual_usage = 0
    for key, value in tmp_hash
      tmp_hash[key] = (value[0].to_f/value[1].to_f).to_i
      annual_usage += tmp_hash[key]
    end

    @usage_data = tmp_hash.to_a.sort{|a, b| a[0].to_i <=> b[0].to_i}
    @usage_data.insert(0, ["0", annual_usage])

  end

  def update_chart

    if current_user
      @usage_point = current_user.usage_point
    elsif session['usage-point']
      @usage_point = UsagePoint.find_by_id(session['usage-point'])
    else
      redirect_to :controller => :imports, :action => :new
    end

    unit = params[:unit]

    case unit
    when "day"
      group_by = "year, month, day"
    when "month"
      group_by = "year, month"
    when "week"
      group_by = "year, week"
    when "year"
      group_by = "year"
    when "typical_week"
      group_by = "dow"
    end

    generate_chart(@usage_point.readings, group_by)

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private
    def generate_chart(readings, group_by)
      @start_time = readings.order('start ASC').first.start
      @end_time = readings.order('start DESC').first.start
      @end_time += readings.order('start DESC').first.duration

      select = []

      for unit in group_by.split(", ")
        select += ["EXTRACT(#{unit} from start) as #{unit}"]
      end

      select += ["SUM(value)/1000 as total_per_unit, AVG(cost/value)/100 as average_cost, AVG(value)/1000 as average"]

      select = select.join(", ")

      usage_data_query = readings.
                      order(group_by).
                      group(group_by).
                      select(select)

      @usage_data = usage_data_query.
                      collect {|entry| [generate_timestamp(entry, group_by), entry.total_per_unit.to_f]}
      
      @total_usage = readings.select("SUM(value)/1000 as total")[0].total.to_i
      @average_usage = (@total_usage / @usage_data.size).round(2)
      @average_for_area = 587

      @cost_data = usage_data_query.
                      collect {|entry| [generate_timestamp(entry, group_by), entry.average_cost.to_f.round(4)]}

      @total_cost = readings.select("SUM(cost)/100000 as cost")[0].cost.to_f.round(2)
      @average_cost = (@total_cost / @usage_data.size).round(2)

      @unit = group_by.split(", ").last.to_s

      if params[:unit] == 'day'
        @average_for_area /= 30
      elsif params[:unit] == 'week'
        @average_for_area /= 4
      elsif params[:unit] == 'year'
        @average_for_area *= 12        
      end
    end

    def generate_timestamp(entry, group_by)
      year = 1970
      week = nil
      month = 1
      day = 1

      for field in group_by.split(", ")
        case field
          when "year"
            year = entry[field].to_i
          when "month"
            month = entry[field].to_i
          when "week"
            week = entry[field].to_i
          when "day"
            day = entry[field].to_i
        end
      end

      if week
        puts "Year #{year}, Week #{week}"
        DateTime.strptime("#{year} #{week} 1", "%Y %U %u").to_time.to_i*1000
      else
        DateTime.new(year, month, day).to_time.to_i*1000
      end
    end
end

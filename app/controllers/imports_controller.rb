class ImportsController < ApplicationController

	respond_to :html, :xml, :json

	def new
		respond_with(@import = Import.new)
	end

	def create
		@import = Import.new(params[:import])

		puts "Params: #{params[:import]}"

		if @import.save

			#@import.process
			session['usage-point'] = @import.feed.usage_point.id

			flash[:notice] = "Import Processed"

			respond_to do |format|
				format.html {redirect_to dashboard_url}
				format.js {redirect_to dashboard_url}
			end
		else
			flash[:notice] = "There were errors importing your file."

			respond_to do |format|
				format.html { render 'new' }
				format.js { render :partial => "layouts/errors", :locals => {:object => @import}, :status => :unprocessable_entity }
			end
		end
	end
end

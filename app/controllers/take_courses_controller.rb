class TakeCoursesController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@take_courses = current_user.take_courses.includes(:course)
	end
end

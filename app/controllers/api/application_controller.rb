module Api
  class ApplicationController < ActionController::API

    include DeviseTokenAuth::Concerns::SetUserByToken
        
    devise_token_auth_group :member, contains: [:user]
    #before_action :authenticate_member!

    def index
      render json: scoped_collection, status: :ok
    end

    def show
      if requested_object.present?
        render json: requested_object, status: :ok
      else
        render json: {message: "could not find resource"}, status: :unprocessable_entity
      end
    end

    def update
      resource = requested_object
      if resource.update(object_params)
        render json: resource, status: :ok
      else
        render json: {message: "could not update resource", resource: resource}, 
                      status: :unprocessable_entity
      end
    end

    def create
      resource = object_class.new(object_params)
      if resource.save
        render json: resource, status: :ok
      else
        render json: {message: "could not create resource", resource: resource}, 
                      status: :unprocessable_entity
      end
    end

    def destroy
      requested_object.destroy
      render json: {success: true}, status: :ok
    end

    # ParamError is superclass of ParamMissing, ParamInvalid
    rescue_from Apipie::ParamError do |e|
      render json: e.message, status: 400
    end

    private
      def scoped_collection
        klass = object_class
        klass.all
      end

      def requested_object
        @requested_object ||= find_object(params[:id])
      end

      def find_object(param)
        object_class.find(param)
      end

      def object_class
        Object.const_get(object_class_name)
      end

      def object_class_name
        object_name.camelize
      end

      def object_name
        controller_name.split("/").last.singularize
      end

      def object_params
        #TODO: fix it!
        params.permit(*permitted_object_params)
        #params.require(object_name).permit(*permitted_object_params)
      end

      def permitted_object_params
        object_class.attribute_names
      end


  end
end
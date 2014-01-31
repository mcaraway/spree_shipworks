module Spree
  module Shipworks
    class ApiController < ApplicationController
      def action
        response.content_type = 'text/xml'
        dispatch_action(api_action.downcase)
      end

      private

      def actions
        result = {}
        actions_dir = File.join(Spree::Shipworks::Engine.root, 'app', 'actions', 'spree','shipworks')
        Dir.glob(File.join(actions_dir, '*.rb')) do |action_file|
          action_file_basename = File.basename(action_file)
          action_name = action_file_basename.sub('.rb', '').gsub('_', ' ')
          action_name = action_name.gsub(' ', '').downcase
          action_class_name = "Spree::Shipworks::" + action_file_basename.sub('.rb', '').camelize
          action_class = action_class_name.constantize
          result[action_name] = action_class
        end
        result
      end

      def dispatch_action(action_name)
        if actions[action_name].present?
          action_result = actions[action_name].new.call(request.request_parameters)
          Rails.logger.info(action_result)
          render(:text => action_result)
        elsif action_name == 'version_probe'
          dsl = Object.new.extend(Dsl)
          render(:text => dsl.response {})
        else
          Rails.logger.info("Unknown action `#{action_name}`.")
          dsl = Object.new.extend(Dsl)
          render(:text => dsl.error_response("NOT_FOUND", "Unknown action `#{action_name}`."))
        end
      end

      def invalid_user
        Rails.logger.info("Invalid User")
        dsl = Object.new.extend(Dsl)
        render(:text => dsl.error_response("INVALID_USER_OR_PASSWORD", "Invalid username or password"))
      end

      def unauthorized_user
        Rails.logger.info("Unauthorized User")
        dsl = Object.new.extend(Dsl)
        render(:text => dsl.error_response("UNAUTHORIZED_USER", "The specified user is not a Spree administrator."))
      end

      def authorized?
        valid? && api_user.has_role?(:admin)
      end

      def valid?
        api_user.present? && api_user.valid_password?(api_password)
      end

      def api_user
        @api_user ||= (Spree::User.find_by_email(api_username) || Spree::User.find_by_login(api_username))
      end

      def api_username
        params['username'] || request.request_parameters['username'] || request.query_parameters['username']
      end

      def api_password
        params['password'] || request.request_parameters['password'] || request.query_parameters['password']
      end

      def get_params
        request.request_parameters || request.query_parameters
      end

      def api_action
        request.request_parameters['action'] || request.query_parameters['action']
      end
    end
  end
end
class ApplicationController < ActionController::API

  def require_auth
    @email, @pass = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
    @email.present? && @pass.present? ? get_user : respond_401
  end

  def get_user
    @user = User.find_by(email: @email)
    respond_401 if @user.nil?
  end

  def respond_401
    render json: { status: 401, error: 'Unauthorized' }, status: 401 and return
  end

  def respond_404
    render json: { status: 404, error: 'Not found' }, status: 404 and return
  end

  def respond_409(msg = 'Request Conflict')
    render json: { status: 409, error: msg }, status: 409 and return
  end

  def check_for_expired_resources
    Resource.check_lease_expiration
  end

end

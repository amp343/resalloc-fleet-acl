class ResourcesController < ApplicationController

  before_filter :check_for_expired_resources
  before_filter :require_auth, only: [ :lease, :unlease, :leased_to_user ]
  before_filter :ensure_resource, only: [ :show, :leased, :lease, :unlease ]

  def index
    render json: ActiveModel::ArraySerializer.new(
      Resource.all,
      each_serializer: ResourceSerializer
    ).to_json
  end

  def show
    render json: ResourceSerializer.new(@resource).to_json
  end

  def lease
    return respond_409('You cannot lease more than 1 server at a time') if Resource.leased_to_user(@user).present?
    return respond_409(
      'The requested resource is already leased to another user. It will be available again in ' + @resource.lease_remaining
    ) if @resource.is_leased?

    # else, we can lease this resource as requested
    @resource.lease_to_user(@user)
    render json: ResourceSerializer.new(@resource).to_json
  end

  def unlease
    return respond_409('You cannot unlease a server that you have not leased') unless @resource.is_leased_to_user?(@user)

    # else, we can unlease this resource as requested
    @resource.unlease
    render json: ResourceSerializer.new(@resource).to_json
  end

  def leased_to_user
    render json: ActiveModel::ArraySerializer.new(
      Resource.leased_to_user(@user),
      each_serializer: ResourceSerializer
    ).to_json
  end

  #
  # filters
  #

  private

  def ensure_resource
    # cannot lease a missing resource
    @resource = Resource.find_by(name: params[:name])
    respond_404 unless @resource.present?
  end

end

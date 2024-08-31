class EventPolicy
  attr_reader :user, :event

  def initialize(user, event)
    @user = user
    @event = event
  end

  def destroy?
    @event.user === @user
  end

  def update?
    @event.user === @user
  end


end
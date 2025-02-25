class GroupsController < ApplicationController
  def create
    @group = Current.user.groups.build(group_params)

    if @group.save
      Current.user.groups << @group
      redirect_to root_path(group_id: @group.id), notice: "Group created successfully."
    else
      redirect_to root_path, alert: @group.errors.full_messages.to_sentence
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end

class ClassroomAnimations::ClosuresController < ApplicationController
  def create
    @classroom_animation = ClassroomAnimation.find(params[:classroom_animation_id])
    authorize @classroom_animation
    @classroom_animation.update(opened: false)

    webhook_body = {
      text: "Fermeture de la salle de #{@classroom_animation.classroom.name} du #{l(@classroom_animation.starts_at, format: "%A %d/%m/%Y à %H:%M")} de #{@classroom_animation.childrens_maximum} enfants maximum par #{@classroom_animation.user.full_name}"
    }
    HTTParty.post(ENV['WEBHOOK_URL'], body: webhook_body.to_json, headers: { 'Content-Type': 'application/json' })

    redirect_to classroom_animation_path(@classroom_animation)
  end
end

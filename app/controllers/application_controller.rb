require 'application_helper'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  def common_content
    @root_topics = Topic.roots
    @family_history = Topic.where(name: "family history")[0].self_and_descendants
    @genetics = Topic.where(name: "genetics")[0].self_and_descendants
    @medication = Topic.where(name: "medication")[0].self_and_descendants
    @cardiovascular = Topic.where(name: "cardiovascular")[0].self_and_descendants
    @pulmonary = Topic.where(name: "pulmonary")[0].self_and_descendants
    @ortho = Topic.where(name: "orthopedic")[0].self_and_descendants
    @ophthalmo = Topic.where(name: "ophthalmologic")[0].self_and_descendants

    @stats = Topic.where(topic_type: "stat")

    @root = Topic.where(parent_id: Topic.where(name: "aortic root")[0])
    @asc = Topic.where(parent_id: Topic.where(name: "ascending aortic")[0])
    @transv = Topic.where(parent_id: Topic.where(name: "transverse arch")[0])
    @desc = Topic.where(parent_id: Topic.where(name: "descending thoracic aorta")[0])
    @supra = Topic.where(parent_id: Topic.where(name: "suprarenal abdominal aorta")[0])
    @infra = Topic.where(parent_id: Topic.where(name: "infrarenal abdominal aorta")[0])
    @annulus = Topic.where(parent_id: Topic.where(name: "aortic annulus")[0])

    @heart_imaging_locations = [@root, @asc, @transv, @desc, @supra, @infra, @annulus]

    @parent = Topic.where(name: "parent")[0]
    @sibling = Topic.where(name: "sibling")[0]
    @child = Topic.where(name: "child")[0]
  end

end

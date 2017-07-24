require "administrate/base_dashboard"

class AdminUserDashboard < ApplicationDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    phone: Field::String,
    superadmin: Field::Boolean,
    email: Field::String,
    town: Field::BelongsTo,
    password: Field::Password
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :phone,
    :email,
    :town,
    :superadmin
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :phone,
    :email,
    :town,
    :superadmin
  ]

  SEARCHABLE_ATTRIBUTES = [
    #[:id_eq, {input_html: {type: :number, min: 0}}],
    [:name_cont],
    [:email_cont],
    [:town_id_eq, {as: :select, 
              collection: Town.all,
              include_blank: true,
              input_html: { class: "form-control js-select2" },
              value_method: :id,
              label_method: -> (t) { 
                  t.try(:to_s)
                }
              }]
  ]

  def self.search_path
    Rails.application.routes.url_helpers.admin_admin_users_path
  end

  # Overwrite this method to customize how admin users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(admin_user)
  #   "AdminUser ##{admin_user.id}"
  # end
end

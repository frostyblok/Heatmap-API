class Employee < ApplicationRecord
  has_many :responses

  scope :all_employees_driver_names_with_department_and_scores, -> {
    includes(:responses).where.not(responses: { id: nil }).pluck(:driver_name, :department, :score)
  }
end

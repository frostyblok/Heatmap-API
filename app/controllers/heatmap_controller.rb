class HeatmapController < ApplicationController
  def index
    render json: employees_heat_map
  end

  def create
    employee = Employee.create!(employee_params)

    render json: { employee: employee, status: 201 }
  end

  private

  def employees_heat_map
    heat_map = []
    transformed_employees_happiness_data = transform_employees_happiness

    transformed_employees_happiness_data.each do |key, _|
      heat_map.push({driver: key.to_s, score: transformed_employees_happiness_data[key.to_s]})
    end

    heat_map
  end

  def transform_employees_happiness
    employees_happiness = Hash.new { |h,k| h[k] = [] }

    employees.each do |employee|
      employees_happiness[employee[0]] += [[employee[1], employee[2]]]
    end

    employees_happiness.transform_values do |value|
      value.group_by {|x| x[0]}.transform_values do |e|
        all_scores = e.map { |k| k[1].to_i }
        (all_scores.sum/(all_scores.size + 0.0)).round(2)
      end
    end
  end

  def employees
    @employees ||= Employee.all_employees_driver_names_with_department_and_scores
  end

  def employee_params
    params.permit(:name, :email, :department, :location, :gender, :age)
  end
end

module ParamsHelpers
  def permitted_params
    declared params, include_missing: false
  end
end

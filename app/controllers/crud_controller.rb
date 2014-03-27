class CRUDController < ApplicationController

	layout_by_action 'default', :index => 'crud_list', [:show, :new, :edit] => 'crud_form'

end
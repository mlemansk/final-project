Rails.application.routes.draw do
  devise_for :users
  
  root 'loans#index'
  
  # Routes for the Pmt adjustment resource:

  # CREATE
  get("/pmt_adjustments/new", { :controller => "pmt_adjustments", :action => "new_form" })
  post("/create_pmt_adjustment", { :controller => "pmt_adjustments", :action => "create_row" })

  # READ
  get("/pmt_adjustments", { :controller => "pmt_adjustments", :action => "index" })
  get("/pmt_adjustments/:id_to_display", { :controller => "pmt_adjustments", :action => "show" })

  # UPDATE
  get("/pmt_adjustments/:prefill_with_id/edit", { :controller => "pmt_adjustments", :action => "edit_form" })
  post("/update_pmt_adjustment/:id_to_modify", { :controller => "pmt_adjustments", :action => "update_row" })

  # DELETE
  get("/delete_pmt_adjustment/:id_to_remove", { :controller => "pmt_adjustments", :action => "destroy_row" })

  #------------------------------

  # Routes for the Loan resource:

  # CREATE
  get("/loans/new", { :controller => "loans", :action => "new_form" })
  post("/create_loan", { :controller => "loans", :action => "create_row" })

  # READ
  get("/loans", { :controller => "loans", :action => "index" })
  get("/loans/:id_to_display", { :controller => "loans", :action => "show" })

  # UPDATE
  get("/loans/:prefill_with_id/edit", { :controller => "loans", :action => "edit_form" })
  post("/update_loan/:id_to_modify", { :controller => "loans", :action => "update_row" })

  # DELETE
  get("/delete_loan/:id_to_remove", { :controller => "loans", :action => "destroy_row" })

  #------------------------------

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

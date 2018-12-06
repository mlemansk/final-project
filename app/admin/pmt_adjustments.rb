ActiveAdmin.register PmtAdjustment do
  permit_params :payment_occurence, :loan_id, :user_id, :pmt_adjustment, :beg_pay_adj, :end_pay_adj, :adjustment_details

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end

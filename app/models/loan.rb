# == Schema Information
#
# Table name: loans
#
#  id                  :integer          not null, primary key
#  current_balance     :float
#  original_amount     :float
#  interest_rate       :float
#  periods_in_year     :integer
#  user_id             :integer
#  loan_name           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  monthly_min_payment :float
#

class Loan < ApplicationRecord
    has_many :pmt_adjustments, :dependent => :destroy
    belongs_to :user
    
    validates :interest_rate, :numericality => { :greater_than => 0 }
    validates :interest_rate, :presence => true
    validates :current_balance, :numericality => { :greater_than => 0 }
    validates :current_balance, :presence => true
    
    def pay_schedule
        i=0;
        end_balance = self.current_balance;
        pmt_amt = self.monthly_min_payment;
        interest_rate =  self.interest_rate.to_f / 100;
        periods = self.periods_in_year;
        mo_int = interest_rate/periods;
        cum_int = 0;
        
        @pmt_schedule = [];
        
        # Loan without any additional payments
        while end_balance > 0
          beg_balance = end_balance;
          pmt_no = i+1;
          interest = beg_balance*mo_int;
          
          # Checks if the scheduled payment exceeds the ammount that is still owed on the loan
          # Adjusts payment down to the beginng balance + interest accrued if it us
           
          if beg_balance + interest < pmt_amt
            pmt_amt = beg_balance + interest;
          end
          
          principal = pmt_amt - interest;
          end_balance = beg_balance - principal;
          cum_int += interest;
          loan_name = self.loan_name
          
          
          @pmt_schedule[i] = {"pmt_no" => pmt_no , "beg_balance" => beg_balance.round(2), "pmt_amt" => pmt_amt , "principal" => principal , "interest" => interest , "end_balance" => end_balance, "cum_int" =>cum_int, "loan_name" => loan_name};
          i += 1;
        end
        
        return @pmt_schedule
    end


    def adj_pay_schedule( pmt_adj_table )
        j=0;
        end_balance_adj = self.current_balance;
        pmt_amt = self.monthly_min_payment;
        interest_rate =  self.interest_rate.to_f / 100;
        periods = self.periods_in_year;
        mo_int = interest_rate/periods;
        cum_int_adj = 0;
        
        @pmt_schedule_adj = [];
        
        while end_balance_adj > 0
          beg_balance_adj = end_balance_adj;
          pmt_amt = self.monthly_min_payment;
          pmt_no = j+1;
          interest = beg_balance_adj*mo_int;
          
          pmt_amt_adj = pmt_amt;
          
          # Checks to see if there are any payment adjustments happpening
          # during this loan period and adjusting payment accordingly
          
          pmt_adj_table.each do | adjustment |
            if adjustment.payment_occurence == "One Time" && adjustment.beg_pay_adj == pmt_no
              pmt_amt_adj += adjustment.pmt_adjustment;
            elsif adjustment.payment_occurence == "Recurring" && adjustment.beg_pay_adj <= pmt_no
              pmt_amt_adj += adjustment.pmt_adjustment;
            elsif adjustment.payment_occurence == "Between" && adjustment.beg_pay_adj <= pmt_no && adjustment.end_pay_adj >= pmt_no
              pmt_amt_adj += adjustment.pmt_adjustment;
            else
              pmt_amt_adj = pmt_amt_adj;
            end
          end
          
          # Checks if the scheduled payment exceeds the ammount that is still owed on the loan
          # Adjusts payment down to the beginng balance + interest accrued if it us
           
          if beg_balance_adj + interest < pmt_amt_adj
            pmt_amt_adj = beg_balance_adj + interest;
          end
          
          principal = pmt_amt_adj - interest;
          end_balance_adj = beg_balance_adj - principal;
          cum_int_adj += interest;
          loan_name = self.loan_name
          
          
          @pmt_schedule_adj[j] = {"pmt_no" => pmt_no , "beg_balance_adj" => beg_balance_adj.round(2), "pmt_amt_adj" => pmt_amt_adj , "principal" => principal , "interest" => interest , "end_balance_adj" => end_balance_adj, "cum_int_adj" =>cum_int_adj, "loan_name" => loan_name};
          j += 1;
        end    
        
        
        
        return @pmt_schedule_adj
    end
    
end

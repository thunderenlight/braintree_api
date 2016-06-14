require 'sinatra'
require 'braintree'
 

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = '23nd25g4kn7gnqbb'
Braintree::Configuration.public_key = '8552x2ym5bvhsycp'
Braintree::Configuration.private_key = '17f3279171d4fd90ee9cd5256be17abf'


get '/client_token' do 
	@client_token = Braintree::ClientToken.generate
	erb :index
end

post '/checkout' do 
	cust = Braintree::Customer.create(
		
		)
		if cust.success?
		  puts cust.customer.id
		  @cust = cust.customer.id
		else
		  p cust.errors
		end
	puts cust.customer.id
	puts "*****"
	@amount = params[:amount]
	payment_method_nonce = params[:payment_method_nonce]
# 	sale_result = Braintree::Transaction.sale(
# 	  :amount => "100",
# 	  :payment_method_nonce => fake-processor-declined-visa-nonce,
# 	  :options => {
# 	    :submit_for_settlement => true
# 	  }
# 	)

# puts new_result = Braintree::TestTransaction.settle(sale_result.transaction.id)
# puts new_result.success? == true
# puts new_result.transaction.status == Braintree::Transaction::Status::Settled

	@result = Braintree::Transaction.sale(
		amount: @amount,
		payment_method_nonce: payment_method_nonce,
		customer_id: cust.customer.id,
		options: {
    		store_in_vault_on_success: true
  		}
	)
	if @result.success?# || result.errors.any? {|error| error.code == "91609"}
		@transaction = @result.transaction
		erb :checkout
	else
		error_messages = @result.errors.map { |error| "Error: #{error.code}: #{error.message}" } 
	end	 
end
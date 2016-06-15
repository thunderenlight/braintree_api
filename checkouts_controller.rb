require 'sinatra'
require 'braintree'
require 'awesome_print'


Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = '23nd25g4kn7gnqbb'
Braintree::Configuration.public_key = '8552x2ym5bvhsycp'
Braintree::Configuration.private_key = '17f3279171d4fd90ee9cd5256be17abf'


get '/client_token' do 
	@client_token = Braintree::ClientToken.generate
	erb :index
end

post '/checkout' do 
	@amount = params[:amount]
	payment_method_nonce = params[:payment_method_nonce]

	cust = Braintree::Customer.create(
		first_name: "John",
		last_name: "Doe"
		)
		if cust.success?
		  puts cust.customer.id
		  @cust = cust.customer.id
		else
		  cust.errors
		end

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
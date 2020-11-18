class CheckoutController < ApplicationController
  def index
    redirect_to 'https://eventswish.com'
  end

  def cancellation_request
    CancelMailer.send_cancel_request(params).deliver_now
  end

  def checkout_session
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    render json: { session: session }
  end

  def create_checkout_session
    begin
      session = Stripe::Checkout::Session.create(
        success_url: ENV['DOMAIN'] + "/account/upgrade?plan_title=#{params[:plan]}&session_id={CHECKOUT_SESSION_ID}",
        cancel_url: ENV['DOMAIN'] + '/account/upgrade',
        payment_method_types: ['card'],
        mode: 'subscription',
        line_items: [{
          quantity: 1,
          price: ENV["#{params[:planType].upcase}_#{params[:plan].upcase}_PRICE_ID"],
        }],
      )
    rescue => e
      return render json: { error: { message: e.message } }, status: 400
    end

    render json: { session_id: session }
  end

  def customer_portal
    checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])

    session = Stripe::BillingPortal::Session.create({
      customer: checkout_session['customer'],
      return_url: ENV['DOMAIN']
    })
    render json: { url: session.url }
  end

  def upgrade
    subscription = Stripe::Subscription.retrieve(params[:subscription])

    new_subscription = Stripe::Subscription.update(
      subscription.id,
      {
        cancel_at_period_end: false,
        proration_behavior: 'always_invoice',
        items: [
          {
            id: subscription.items.data[0].id,
            price: ENV["#{params[:plan_type].upcase}_PREFERRED_PRICE_ID"]
          }
        ]
      }
    )
    render json: { status: 'ok', subscription: new_subscription }
  rescue => e
    render json: { error: e.message }, status: 400
  end

end

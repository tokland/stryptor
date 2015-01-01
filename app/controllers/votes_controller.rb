class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @vote = Vote.from_params(current_user, [Strip], params)

    respond_to do |format|
      if @vote.save
        format.json do
          render(:json => {
            status: :ok, 
            value: @vote.value, 
            info: @vote.voteable.votes.info,
          })
        end
      else
        format.json { render(:json => {:status => :error}) }
      end
    end
  end
end

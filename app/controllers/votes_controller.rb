class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @vote = Vote.from_params(current_user, [Strip], params)

    respond_to do |format|
      if @vote.save
        format.json do
          render(json: {
            status: true,
            value: @vote.value,
            info: @vote.voteable.votes.info,
          })
        end
      else
        format.json do
          render(json: {
            status: false,
            error: @vote.errors.full_messages.to_sentence,
          })
        end
      end
    end
  end
end

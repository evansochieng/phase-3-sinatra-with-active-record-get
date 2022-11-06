class ApplicationController < Sinatra::Base
  #Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'

  get '/games' do

    # get all the games from the database and order by title
    games = Game.all.order(:title).limit(10)
    # return a JSON response with an array of all the game data
    games.to_json
  end

  get '/games/:id' do
    # look up the game in the database using its ID
    game = Game.find(params[:id])
    # send a JSON-formatted response of the game data
    # include associated reviews in the JSON response
    #game.to_json(include: :reviews)

    #Also include users associated with every review
    #game.to_json(include: { reviews: { include: :user } })

    #Be selective on the attributes you want returned
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

end

class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]

  # GET /players or /players.json
  def index
    @players = Player.order(current_rank: :desc)
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def chess_match
    @players = Player.all
    redirect_to players_path, flash: {notice: "You need at least two players to record a match"} if @players.count < 2
  end

  def create_match
    player_1 = Player.find(params[:player_1])
    player_2 = Player.find(params[:player_2])
    if player_1 == player_2
      redirect_to chess_match_players_path, flash: {notice: "Player 1 and Player 2 cannot be the same person"}
      return
    end
    calculate_player_position(player_1, player_2, params[:match_status])
    redirect_to players_path, flash: {notice: "Match recorded!"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:first_name, :last_name, :email, :birthday, :games_played)
    end

    def calculate_player_position(player_1, player_2, match_status)
      # TODO: refactor this method
      if match_status.to_i == 2
        if player_2.current_rank > player_1.current_rank
          player_2.decrement!(:current_rank, ((player_2.current_rank - player_1.current_rank)/2))
          player_1.increment!(:current_rank)
        end
      end

      if match_status.to_i == 1
        if player_1.current_rank > player_2.current_rank
          player_1.decrement!(:current_rank, ((player_1.current_rank - player_2.current_rank)/2))
          player_2.increment!(:current_rank)
        end
      end

      if match_status.to_i == 3
        players = [player_1, player_2].sort_by(&:current_rank)
        rank_difference = players.last.current_rank - players.first.current_rank
        if rank_difference > 1
          players.last.decrement!(:current_rank)
        end 
      end
      player_1.increment!(:games_played)
      player_2.increment!(:games_played)
    end
end

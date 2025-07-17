import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "playerForm"]

  connect() {
  }

  async addPlayer(event) {
    const sessionId = event.target.dataset.sessionId;
    const currentNumberOfPlayers = this.playerFormTargets.length;
    const maxNumberOfPlayers = event.target.dataset.maxPlayers;
    const url = `/build_player_field?session_id=${sessionId}`;

    const response = await fetch(url);
    if (response.ok && currentNumberOfPlayers < maxNumberOfPlayers) {
      const html = await response.text();
      this.containerTarget.insertAdjacentHTML('beforeend', html);
    } else if (currentNumberOfPlayers >= maxNumberOfPlayers) {
      alert('Too many players')
    } else {
      alert('Failed to fetch new player form.');
    }
  }

  removePlayer(event) {
    event.preventDefault();
    const playerForm = event.target.closest('[data-player-creation-target="playerForm"]');
    if (playerForm) {
      playerForm.remove();
    }
  }
}

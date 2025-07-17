import { Controller } from "@hotwired/stimulus"

// Controls the score input modal for the current round
export default class extends Controller {
  static targets = ["modal", "form", "roundNumber"]

  connect() {
    console.log("connectedE")
  }


  open(event) {
    console.log("open")
    event.preventDefault();
    // Find the round number from the clicked cell
    let roundNumber = null;
    if (event.currentTarget.dataset.roundNumber) {
      roundNumber = event.currentTarget.dataset.roundNumber;
    }
    // Store the round number being edited for later use
    this.editingRoundNumber = roundNumber;
    // Find the round object in the window (injected by ERB)
    let roundData = null;
    if (window.scoreSheetRounds && roundNumber) {
      roundData = window.scoreSheetRounds.find(r => r.data.round_number == roundNumber);
    }
    // Set the round number in the modal header
    if (this.hasRoundNumberTarget) {
      this.roundNumberTarget.textContent = roundNumber ? `Round ${roundNumber}` : '';
    }
    const form = this.formTarget;
    if (roundData) {
      form.action = `/rounds/${roundData.id}`;
      // Fill in scores if present
      if (roundData.data.scores) {
        Object.entries(roundData.data.scores).forEach(([player, score]) => {
          const input = form.querySelector(`.score-input[data-player='${player}']`);
          if (input) input.value = score ?? '';
        });
      } else {
        // Clear all score inputs
        form.querySelectorAll('.score-input').forEach(input => input.value = '');
      }
      // Set finished_first if present
      const select = form.querySelector('select[name="finished_first"]');
      if (select) {
        if (roundData.data.finished_first) {
          select.value = roundData.data.finished_first;
        } else {
          select.selectedIndex = 0;
        }
      }
    } else {
      // No round data, clear form
      form.action = '#';
      form.querySelectorAll('.score-input').forEach(input => input.value = '');
      const select = form.querySelector('select[name="finished_first"]');
      if (select) select.selectedIndex = 0;
    }
    this.modalTarget.style.display = "flex";
  }

  close(event) {
    if (event) event.preventDefault();
    this.modalTarget.style.display = "none";
    this.editingRoundNumber = null;
  }

  submit(event) {
    event.preventDefault();
    const form = this.formTarget;
    const url = form.action;
    const formData = new FormData(form);
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: formData
    })
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json();
      })
      .then(data => {
        // Optionally update the UI with new round data
        // For now, reload the page to reflect changes
        window.location.reload();
      })
      .catch(error => {
        alert('Failed to save round: ' + error.message);
      });
    this.close();
  }
}

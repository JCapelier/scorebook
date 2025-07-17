import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    // Show the modal on first load
    this.modal = document.getElementById('first-player-modal');
    this.select = document.getElementById('first-player-select');
    this.confirm = document.getElementById('first-player-confirm');
    if (this.modal && this.select && this.confirm) {
      this.modal.style.display = '';
      this.confirm.addEventListener('click', () => this.setPositions());
    }
  }

  setPositions() {
    const first = this.select.value;
    // Persist first player selection to backend
    const scoreSheetId = document.body.dataset.scoreSheetId;
    fetch(`/score_sheets/${scoreSheetId}/first_player`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ first_player: first })
    }).then(() => {
      // Reorder table columns
      const table = document.querySelector('table');
      if (table) {
        const ths = Array.from(table.querySelectorAll('thead th')).slice(1); // skip 'Round'
        const idx = ths.findIndex(th => th.textContent.trim() === first);
        if (idx > 0) {
          // Move ths
          const newOrder = ths.slice(idx).concat(ths.slice(0, idx));
          newOrder.forEach((th, i) => th.parentNode.appendChild(th));
          // Move tds in each row
          table.querySelectorAll('tbody tr').forEach(tr => {
            const tds = Array.from(tr.children).slice(1); // skip 'Round' or 'Total'
            const newTds = tds.slice(idx).concat(tds.slice(0, idx));
            newTds.forEach((td, i) => tr.appendChild(td));
          });
        }
      }
      // Hide modal
      if (this.modal) this.modal.style.display = 'none';
    });
  }
}

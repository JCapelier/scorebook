import { getProfilePicUrl } from "../user_profile_pics"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spot", "addButton", "removeButton"]

  connect() {;
    this.attachSpotHandlers();
    this.updateSpots();
    this.updateRemoveButton();
    this.updateAddButton();
  }

  updateAddButton() {
    if (!this.hasAddButtonTarget) return;
    const maxPlayers = parseInt(this.addButtonTarget.dataset.maxPlayers, 10);
    this.addButtonTarget.disabled = this.spotTargets.length >= maxPlayers;
  }

  attachSpotHandlers() {
    this.spotTargets.forEach(spot => {
      spot.onclick = () => this.assignPlayer(spot);
    });
  }

  addSpot() {
    console.log("Add spot clicked");
    const spotCount = this.spotTargets.length;
    const maxSpots = parseInt(this.addButtonTarget.dataset.maxPlayers, 10);
    if (spotCount >= maxSpots) {
      alert("Maximum number of players reached");
      return;
    }
    const newSpot = document.createElement("button");
    newSpot.type = "button";
    newSpot.className = "table-spot btn btn-circle btn-outline absolute";
    newSpot.setAttribute("data-table-player-assignment-target", "spot");
    newSpot.innerText = "+";
    newSpot.style.left = "50%";
    newSpot.style.top = "50%";
    const circleDiv = this.element.querySelector(".relative.w-full.h-full");
    if (circleDiv) {
      circleDiv.appendChild(newSpot);
    } else {
      this.element.appendChild(newSpot);
    }
    this.attachSpotHandlers();
    this.updateSpots();
    this.updateRemoveButton();
    this.refreshSpotLabels();
    console.log("Number of spots after add:", this.spotTargets.length);
    console.log("All spot buttons:", this.spotTargets);
  }
  assignPlayer(spot) {
    // Modal-based editing
    this._editingSpot = spot;
    const modal = document.getElementById('player-name-modal');
    const input = document.getElementById('player-name-input');
    const confirmBtn = document.getElementById('player-name-confirm');
    const cancelBtn = document.getElementById('player-name-cancel');
    if (!modal || !input || !confirmBtn || !cancelBtn) return;
    input.value = spot.innerText === '+' ? '' : spot.innerText;
    modal.classList.remove('hidden');
    input.focus();

    const onConfirm = () => {
      const username = input.value.trim();
      spot.innerHTML = '';
      if (username) {
        spot.classList.add("btn-primary");
        spot.classList.remove("btn-outline");
        // Profile pic (fills the button)
        const img = document.createElement('img');
        img.alt = "Profile picture";
        img.src = getProfilePicUrl(username);
        img.className = "w-full h-full object-cover rounded-full";
        img.setAttribute('data-username', username);
        spot.appendChild(img);
      } else {
        spot.classList.remove("btn-primary");
        spot.classList.add("btn-outline");
        spot.innerText = '+';
      }
      this.refreshSpotLabels();
      let hidden = spot.querySelector("input[type=hidden]");
      if (!hidden) {
        hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "session[players][]";
        spot.appendChild(hidden);
      }
      hidden.value = username;
      modal.classList.add('hidden');
      confirmBtn.removeEventListener('click', onConfirm);
      cancelBtn.removeEventListener('click', onCancel);
    };
    const onCancel = () => {
      modal.classList.add('hidden');
      confirmBtn.removeEventListener('click', onConfirm);
      cancelBtn.removeEventListener('click', onCancel);
    };
    confirmBtn.addEventListener('click', onConfirm);
    cancelBtn.addEventListener('click', onCancel);
    input.addEventListener('keydown', function handler(e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        onConfirm();
        input.removeEventListener('keydown', handler);
      }
      if (e.key === 'Escape') {
        e.preventDefault();
        onCancel();
        input.removeEventListener('keydown', handler);
      }
    });
  }
  removeSpot() {
    const minPlayers = parseInt(this.removeButtonTarget.dataset.minPlayers, 10);
    if (this.spotTargets.length > minPlayers) {
      const lastSpot = this.spotTargets[this.spotTargets.length - 1];
      if (lastSpot) {
        lastSpot.remove();
        this.attachSpotHandlers();
        this.updateSpots();
        this.updateRemoveButton();
        this.updateAddButton();
      }
    }
  }

  updateRemoveButton() {
    if (!this.hasRemoveButtonTarget) return;
    const minPlayers = parseInt(this.removeButtonTarget.dataset.minPlayers, 10);
    this.removeButtonTarget.disabled = this.spotTargets.length <= minPlayers;
  }

  updateSpots() {
    const spots = this.spotTargets;
    const n = spots.length;
    const radius = 140;
    const centerX = 160;
    const centerY = 160;
    spots.forEach((spot, i) => {
      const angle = (2 * Math.PI * i) / n;
      const x = centerX + radius * Math.cos(angle) - spot.offsetWidth / 2;
      const y = centerY + radius * Math.sin(angle) - spot.offsetHeight / 2;
      spot.style.position = "absolute";
      spot.style.left = `${x}px`;
      spot.style.top = `${y}px`;
    });
    this.refreshSpotLabels();
  }

  refreshSpotLabels() {
    // Remove all existing labels
    const labelNodes = this.element.querySelectorAll('[id^="spot-label-"]');
    labelNodes.forEach(node => node.remove());
    // Re-render labels for all assigned spots
    const spots = this.spotTargets;
    const n = spots.length;
    spots.forEach((spot, i) => {
      const img = spot.querySelector('img');
      if (img) {
        const username = img.getAttribute('data-username') || '';
        let nameLabel = document.createElement('div');
        nameLabel.id = `spot-label-${i}`;
        nameLabel.innerText = username;
        nameLabel.className = "text-xs font-medium text-center absolute w-24 pointer-events-none select-none";
        // Calculate position: above for lower half, below for upper half
        nameLabel.style.left = `${spot.offsetLeft + spot.offsetWidth/2 - 48}px`;
        if (i < n / 2) {
          // Below the spot
          nameLabel.style.top = `${spot.offsetTop + spot.offsetHeight + 2}px`;
        } else {
          // Above the spot
          nameLabel.style.top = `${spot.offsetTop - 22}px`;
        }
        spot.parentNode.appendChild(nameLabel);
      }
    });
  }
}

/**
 * Integrated: Direct Airtable REST API Fetch + n8n Webhook Sync (WF-2)
 */

// ---------------------------------------------------------------------------
// 1. CONFIGURATION
// ---------------------------------------------------------------------------
const CONFIG = {
  // Airtable REST API details for direct property catalog fetching
  AIRTABLE_API_KEY: 'YOUR_AIRTABLE_API_KEY', // Replace with your Personal Access Token
  AIRTABLE_BASE_ID: 'YOUR_AIRTABLE_BASE_ID', // Replace with your Airtable Base ID
  
  // Replace this URL once your n8n Webhook node is live in Phase 4
  N8N_WEBHOOK_URL: 'https://n8n.yourdomain.com/webhook/guest-portal-booking' // Replace with your n8n Webhook URL
};

// Static Fallback Properties (Used if Airtable Fetch fails or keys are unset)
const FALLBACK_PROPERTIES = [
  {
    id: 'PROP-001',
    name: 'Lekki Modern 3BR',
    location: 'Lekki Phase 1, Lagos',
    capacity: 6,
    currentPrice: 100000,
    houseRules: 'No parties, No smoking, Max 6 guests',
    image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'
  },
  {
    id: 'PROP-002',
    name: 'Ikoyi Waterfront Suite',
    location: 'Ikoyi, Lagos',
    capacity: 4,
    currentPrice: 140000,
    houseRules: 'No loud music after 10 PM, No smoking',
    image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80'
  },
  {
    id: 'PROP-003',
    name: 'Victoria Island Penthouse',
    location: 'Victoria Island, Lagos',
    capacity: 8,
    currentPrice: 220000,
    houseRules: 'No commercial photography, Max 8 guests',
    image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80'
  }
];

// Active property catalog array
let properties = [];

// ---------------------------------------------------------------------------
// 2. INITIALIZATION & DATA FETCHING
// ---------------------------------------------------------------------------
document.addEventListener('DOMContentLoaded', async () => {
  setupEventListeners();
  await loadProperties();
});

/**
 * Fetches properties directly from Airtable API; falls back to static dataset on error
 */
async function loadProperties() {
  const isConfigured = !CONFIG.AIRTABLE_API_KEY.includes('YOUR_') && !CONFIG.AIRTABLE_BASE_ID.includes('YOUR_');

  if (!isConfigured) {
    console.warn('Airtable credentials not provided in CONFIG. Loading static fallback dataset.');
    properties = FALLBACK_PROPERTIES;
    renderProperties();
    return;
  }

  try {
    const response = await fetch(`https://api.airtable.com/v0/${CONFIG.AIRTABLE_BASE_ID}/Properties`, {
      headers: {
        Authorization: `Bearer ${CONFIG.AIRTABLE_API_KEY}`
      }
    });

    if (!response.ok) {
      throw new Error(`Airtable API error: ${response.statusText} (${response.status})`);
    }

    const data = await response.json();

    // Transform Airtable records to local JSON schema
    properties = data.records.map(record => {
      const fields = record.fields;
      return {
        id: fields['Property ID'] || record.id,
        recordId: record.id,
        name: fields['Property Name'] || fields['Name'] || 'Luxury Rental',
        location: fields['Location'] || 'Lagos, Nigeria',
        capacity: fields['Capacity'] || 4,
        currentPrice: fields['Current Price'] || 100000,
        houseRules: fields['House Rules'] || 'Standard Stay Rules Apply',
        image: fields['Image URL'] || 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'
      };
    });

    if (properties.length === 0) {
      console.warn('Airtable returned 0 properties. Using fallback properties.');
      properties = FALLBACK_PROPERTIES;
    }

  } catch (error) {
    console.error('Failed to fetch properties from Airtable. Using fallback properties:', error);
    properties = FALLBACK_PROPERTIES;
  } finally {
    renderProperties();
  }
}

// ---------------------------------------------------------------------------
// 3. UI RENDERING
// ---------------------------------------------------------------------------
function renderProperties() {
  const grid = document.getElementById('property-grid');
  if (!grid) return;

  grid.innerHTML = properties.map(p => `
    <div class="bg-white rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition overflow-hidden flex flex-col">
      <img src="${p.image}" alt="${p.name}" class="w-full h-48 object-cover">
      <div class="p-5 flex-grow flex flex-col justify-between">
        <div>
          <div class="flex justify-between items-start mb-2">
            <h3 class="text-lg font-bold text-gray-900">${p.name}</h3>
            <span class="text-sm font-black text-indigo-600 bg-indigo-50 px-2 py-1 rounded">
              $${(p.currentPrice || 0).toLocaleString()}<span class="text-xs font-normal text-gray-500">/night</span>
            </span>
          </div>
          <p class="text-xs text-gray-500 mb-3">${p.location}</p>
          <div class="text-xs text-gray-600 mb-2">
            <strong>Capacity:</strong> ${p.capacity} Guests
          </div>
          <div class="text-xs text-gray-500 italic bg-gray-50 p-2 rounded border border-gray-100 mb-4">
            <strong>Rules:</strong> ${p.houseRules}
          </div>
        </div>
        <button onclick="openBookingModal('${p.id}')" 
                class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 rounded-lg text-sm transition">
          Book Reservation
        </button>
      </div>
    </div>
  `).join('');
}

// ---------------------------------------------------------------------------
// 4. MODAL CONTROLS & EVENT HANDLERS
// ---------------------------------------------------------------------------
function openBookingModal(propertyId) {
  const property = properties.find(p => p.id === propertyId);
  if (!property) return;

  document.getElementById('form-property-id').value = property.id;
  document.getElementById('modal-property-title').textContent = property.name;
  document.getElementById('modal-property-sub').textContent = `${property.location} • Max Capacity: ${property.capacity}`;
  document.getElementById('form-rate-display').value = `$${(property.currentPrice || 0).toLocaleString()} / night`;
  
  // Set date constraints (minimum date = today)
  const today = new Date().toISOString().split('T')[0];
  document.getElementById('form-checkin').min = today;
  document.getElementById('form-checkout').min = today;

  document.getElementById('booking-modal').classList.remove('hidden');
}

function closeModal() {
  document.getElementById('booking-modal').classList.add('hidden');
  document.getElementById('booking-form').reset();
  hideAlert();
}

function setupEventListeners() {
  document.getElementById('close-modal-btn')?.addEventListener('click', closeModal);
  document.getElementById('cancel-modal-btn')?.addEventListener('click', closeModal);
  document.getElementById('booking-form')?.addEventListener('submit', handleFormSubmit);
}

// ---------------------------------------------------------------------------
// 5. FORM SUBMISSION TO N8N WEBHOOK (WF-2)
// ---------------------------------------------------------------------------
async function handleFormSubmit(event) {
  event.preventDefault();

  const checkIn = new Date(document.getElementById('form-checkin').value);
  const checkOut = new Date(document.getElementById('form-checkout').value);

  if (checkOut <= checkIn) {
    showAlert('Check-out date must be later than check-in date.', 'error');
    return;
  }

  setLoadingState(true);

  // Payload structure sent to WF-2 Pipeline
  const payload = {
    property_id: document.getElementById('form-property-id').value,
    guest_name: document.getElementById('form-guest-name').value.trim(),
    guest_email: document.getElementById('form-guest-email').value.trim(),
    check_in: document.getElementById('form-checkin').value,
    check_out: document.getElementById('form-checkout').value,
    guest_count: parseInt(document.getElementById('form-guest-count').value, 10),
    rental_purpose: document.getElementById('form-purpose').value.trim(),
    submitted_at: new Date().toISOString()
  };

  try {
    const response = await fetch(CONFIG.N8N_WEBHOOK_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (response.ok) {
      showAlert('Booking request submitted! Our automated risk engine is evaluating your reservation. Look Out for an Email with the Evaluation Results.', 'success');
      setTimeout(() => closeModal(), 3000);
    } else {
      throw new Error(`Server returned HTTP ${response.status}`);
    }
  } catch (error) {
    showAlert(`Submission error: (${error.message}). Payload printed to console.`, 'error');
    console.log('Outgoing JSON Payload Debug:', JSON.stringify(payload, null, 2));
  } finally {
    setLoadingState(false);
  }
}

// ---------------------------------------------------------------------------
// 6. UI HELPERS
// ---------------------------------------------------------------------------
function setLoadingState(isLoading) {
  const submitBtn = document.getElementById('submit-btn');
  const btnText = document.getElementById('btn-text');

  if (!submitBtn || !btnText) return;

  if (isLoading) {
    submitBtn.disabled = true;
    submitBtn.classList.add('opacity-75', 'cursor-not-allowed');
    btnText.textContent = 'Processing Request...';
  } else {
    submitBtn.disabled = false;
    submitBtn.classList.remove('opacity-75', 'cursor-not-allowed');
    btnText.textContent = 'Submit Request';
  }
}

function showAlert(message, type) {
  const alertEl = document.getElementById('form-alert');
  if (!alertEl) return;

  alertEl.textContent = message;
  alertEl.className = 'p-3 rounded-lg text-sm font-medium'; // Reset classes

  if (type === 'error') {
    alertEl.classList.add('bg-red-50', 'text-red-700', 'border', 'border-red-200');
  } else {
    alertEl.classList.add('bg-emerald-50', 'text-emerald-700', 'border', 'border-emerald-200');
  }
  alertEl.classList.remove('hidden');
}

function hideAlert() {
  const alertEl = document.getElementById('form-alert');
  if (alertEl) {
    alertEl.classList.add('hidden');
  }
}
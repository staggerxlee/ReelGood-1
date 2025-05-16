document.addEventListener('DOMContentLoaded', function () {
  // Get parameters from URL
  const urlParams = new URLSearchParams(window.location.search);
  const movieId = urlParams.get('id') || '1';
  const time = urlParams.get('time') || '3:00 PM';
  const date = urlParams.get('date') || 'today';

  // Set back link
  document.getElementById('back-to-movie').href = `movie-details.html?id=${movieId}`;

  // Load movie data
  loadMovieData(movieId);

  // Set booking details
  document.getElementById('booking-time').textContent = time;
  document.getElementById('booking-date').textContent = formatDate(date);
  document.getElementById('summary-time').textContent = time;
  document.getElementById('summary-date').textContent = formatDate(date);

  // Generate seats
  generateSeats();

  // Set up checkout button
  document.getElementById('checkout-btn').addEventListener('click', function () {
    const selectedSeats = getSelectedSeats();
    if (selectedSeats.length === 0) return;

    // Disable button and show processing state
    this.disabled = true;
    this.textContent = 'Processing...';

    // Simulate API call with timeout
    setTimeout(() => {
      window.location.href = `confirmation.html?id=${movieId}&seats=${selectedSeats.join(',')}&time=${encodeURIComponent(time)}&date=${date}`;
    }, 1500);
  });
});

function loadMovieData(movieId) {
  // In a real app, this would be fetched from an API
  const movies = [
    {
      id: "1",
      title: "Interstellar: Beyond Time",
      rating: "PG-13",
      duration: "2h 45m",
    },
    {
      id: "2",
      title: "The Last Guardian",
      rating: "PG",
      duration: "1h 55m",
    },
  ];

  // Find the movie by ID
  const movie = movies.find(m => m.id === movieId) || movies[0];

  // Update the page with movie details
  document.getElementById('movie-title').textContent = movie.title;
  document.getElementById('movie-meta').textContent = `${movie.rating} • ${movie.duration}`;
}

function generateSeats() {
  const rows = ["A", "B", "C", "D", "E", "F", "G", "H"];
  const bookedSeats = ["A1", "A2", "B5", "C7", "C8", "C9", "D4", "E5", "E6", "F2", "F3", "G7", "H1", "H2", "H3"];
  const container = document.getElementById('seats-container');

  rows.forEach(row => {
    const rowElement = document.createElement('div');
    rowElement.className = 'seat-row';

    // Add row label at the beginning
    const startLabel = document.createElement('div');
    startLabel.className = 'row-label';
    startLabel.textContent = row;
    rowElement.appendChild(startLabel);

    // Add seats
    for (let i = 1; i <= 10; i++) {
      const seatId = `${row}${i}`;
      const seat = document.createElement('div');
      seat.className = 'seat';
      seat.dataset.seatId = seatId;
      seat.textContent = i;

      if (bookedSeats.includes(seatId)) {
        seat.classList.add('taken');
      } else {
        seat.classList.add('available');
        seat.addEventListener('click', () => toggleSeat(seatId));
      }

      rowElement.appendChild(seat);
    }

    // Add row label at the end
    const endLabel = document.createElement('div');
    endLabel.className = 'row-label';
    endLabel.textContent = row;
    rowElement.appendChild(endLabel);

    container.appendChild(rowElement);
  });
}

function toggleSeat(seatId) {
  const selectedSeats = getSelectedSeats();
  const seatElement = document.querySelector(`.seat[data-seat-id="${seatId}"]`);

  if (seatElement.classList.contains('selected')) {
    // Deselect the seat
    seatElement.classList.remove('selected');
    seatElement.classList.add('available');
  } else {
    // Check if max seats (8) are already selected
    if (selectedSeats.length >= 8) {
      alert('You can select up to 8 seats per booking.');
      return;
    }

    // Select the seat
    seatElement.classList.remove('available');
    seatElement.classList.add('selected');
  }

  // Update the summary
  updateSummary();
}

function getSelectedSeats() {
  const selectedSeatElements = document.querySelectorAll('.seat.selected');
  return Array.from(selectedSeatElements).map(seat => seat.dataset.seatId).sort();
}

function updateSummary() {
  const selectedSeats = getSelectedSeats();
  const seatCount = selectedSeats.length;
  const seatPrice = seatCount * 200;
  const bookingFee = seatCount * 10;
  const totalPrice = seatPrice + bookingFee;

  // Update seat list
  document.getElementById('selected-seats-list').textContent = selectedSeats.length > 0 ? selectedSeats.join(', ') : 'None';

  // Update seat count
  document.getElementById('seat-count').textContent = seatCount;

  // Update prices
  document.getElementById('seats-price').textContent = `Rs${seatPrice.toFixed(2)}`;
  document.getElementById('booking-fee').textContent = `Rs${bookingFee.toFixed(2)}`;
  document.getElementById('total-price').textContent = `Rs${totalPrice.toFixed(2)}`;

  // Enable/disable checkout button
  document.getElementById('checkout-btn').disabled = seatCount === 0;
}

function formatDate(dateStr) {
  const today = new Date();

  if (dateStr === 'today') {
    return today.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' });
  }

  if (dateStr === 'tomorrow') {
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    return tomorrow.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' });
  }

  if (dateStr === 'day-after') {
    const dayAfter = new Date(today);
    dayAfter.setDate(today.getDate() + 2);
    return dayAfter.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' });
  }

  return dateStr;
}

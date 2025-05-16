document.addEventListener('DOMContentLoaded', function() {
    // Initialize Feather icons
    feather.replace();
    
    // Get movie ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const movieId = urlParams.get('id') || '1';
    
    // Load movie data
    loadMovieDetails(movieId);
    
    // Tab functionality
    const tabTriggers = document.querySelectorAll('.tab-trigger');
    tabTriggers.forEach(trigger => {
      trigger.addEventListener('click', () => {
        const tabId = trigger.getAttribute('data-tab');
        
        // Update active tab trigger
        document.querySelectorAll('.tab-trigger').forEach(t => {
          t.classList.remove('active');
        });
        trigger.classList.add('active');
        
        // Show active tab content
        document.querySelectorAll('.tab-content').forEach(content => {
          content.classList.remove('active');
        });
        document.getElementById(tabId).classList.add('active');
      });
    });
  });
  
  function loadMovieDetails(movieId) {
    // In a real app, this would be fetched from an API
    const movies = [
      {
        id: "1",
        title: "Interstellar: Beyond Time",
        posterUrl: "images/movie.jpg",
        rating: "PG-13",
        rating_score: 8.7,
        duration: "2h 45m",
        genre: "Sci-Fi/Adventure",
        description:
          "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival. As they journey to another galaxy, they face the harsh realities of interstellar travel and the mysteries of the universe.",
        cast: "Matthew McConaughey, Anne Hathaway, Jessica Chastain, Michael Caine",
        director: "Christopher Nolan",
      },
      {
        id: "2",
        title: "Sikandar",
        posterUrl: "images/sikander.jpg",
        rating: "PG",
        rating_score: 7.9,
        duration: "2h 26m",
        genre: "Action/Drama",
        description:
          "A fiery youth confronts a powerful network of corruption, challenging the status quo and fighting for the common people's rights in a nation gripped by injustice.",
        cast: "Salman KhanRashmika MandannaSuniel Shetty",
        director: "A.R. Murugadoss",
      },
      {
        id: "3",
        title: "Anjila",
        posterUrl: "images/anjila.jpg",
        rating: "U",
        rating_score: 8.7,
        duration: "2h 45m",
        genre: "Biography, Drama",
        description:
          "The movie 'Anjila' is based on the real-life story of Anjila Tumbapo Subba, the captain and number one goalkeeper of Nepal's national women's football team. The film showcases her journey from being confined within her home to becoming the team captain, highlighting her struggles and determination .Anjila herself plays the lead role, with Dayahang Rai and Srijana Subba portraying her parents The movie emphasizes the importance of perseverance and the belief that with determination, nothing is impossible.",
        cast: "Dayahang RaiAnjila Tumbapo SubbaSrijana SubbaMaotse Gurung",
        director: "Milan Chams",
      }
    ];
    
    // Find the movie by ID
    const movie = movies.find(m => m.id === movieId) || movies[0];
    
    // Update the page with movie details
    document.getElementById('movie-title').textContent = movie.title;
    document.getElementById('movie-poster').src = movie.posterUrl;
    document.getElementById('movie-poster').alt = movie.title;
    document.getElementById('movie-duration').textContent = movie.duration;
    document.getElementById('movie-genre').textContent = movie.genre;
    document.getElementById('movie-rating').textContent = movie.rating;
    document.getElementById('rating-score').textContent = `${movie.rating_score}/10`;
    document.getElementById('movie-description').textContent = movie.description;
    document.getElementById('movie-cast').textContent = movie.cast;
    document.getElementById('movie-director').textContent = movie.director;
    
    // Load showtimes
    loadShowtimes(movieId);
  }
  
  function loadShowtimes(movieId) {
    const showtimes = ["10:00 AM", "12:30 PM", "3:00 PM", "5:30 PM", "8:00 PM", "10:30 PM"];
    
    // Create showtimes for each day
    const days = ['today', 'tomorrow', 'day-after'];
    days.forEach(day => {
      const container = document.getElementById(`${day}-showtimes`);
      
      showtimes.forEach(time => {
        const button = document.createElement('button');
        button.className = 'btn btn-outline';
        button.textContent = time;
        button.addEventListener('click', () => {
          window.location.href = `booking.html?id=${movieId}&time=${encodeURIComponent(time)}&date=${day}`;
        });
        
        container.appendChild(button);
      });
    });
  }
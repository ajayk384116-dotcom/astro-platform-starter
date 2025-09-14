<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>A Special Surprise!</title>
    <!-- Google Fonts for a modern, elegant look -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS for utility-first styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            overflow: hidden; /* Prevent scrolling during animation */
            background-color: #f0f4f8;
        }
        /* Custom keyframes for the smooth background gradient animation */
        @keyframes gradient-animation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .animated-gradient {
            background: linear-gradient(-45deg, #FFDAB9, #FFC0CB, #ADD8E6, #D8BFD8);
            background-size: 400% 400%;
            animation: gradient-animation 15s ease infinite;
        }
        /* Custom keyframes for the countdown fade-in/out effect */
        @keyframes number-pulse {
            0% { opacity: 0; transform: scale(0.5); }
            50% { opacity: 1; transform: scale(1); }
            100% { opacity: 0; transform: scale(1.5); }
        }
        .number-animation {
            animation: number-pulse 1s ease-in-out forwards;
        }
        /* Custom class for the soft fade-in animation on the main content */
        .fade-in {
            transition: opacity 2s ease-in;
        }
    </style>
</head>
<body class="bg-gray-100">

    <!-- Loading Screen with Countdown -->
    <div id="loading-screen" class="animated-gradient fixed inset-0 z-50 flex flex-col items-center justify-center text-white text-center transition-opacity duration-1000 ease-in-out">
        <h1 class="text-3xl md:text-5xl font-bold mb-8 drop-shadow-lg">🎉 Surprise Loading…</h1>
        <div id="countdown" class="text-6xl md:text-8xl font-extrabold drop-shadow-lg">5</div>
    </div>

    <!-- Main Content (initially hidden) -->
    <div id="main-content" class="min-h-screen flex flex-col items-center justify-center p-4 md:p-8 opacity-0 fade-in bg-gray-100">
        <!-- Message Card -->
        <div class="bg-white rounded-2xl shadow-2xl p-6 md:p-12 text-center max-w-2xl w-full mx-auto transform translate-y-8 opacity-0 transition-all duration-1000 ease-out" id="message-card">
            <h1 id="occasion-title" class="text-3xl md:text-5xl font-bold text-gray-800 mb-4">Happy Birthday!</h1>
            <p class="text-lg md:text-xl text-gray-600 font-light">A special surprise just for you!</p>
        </div>

        <!-- Flipbook Section -->
        <div class="w-full max-w-5xl mt-8 md:mt-12 text-center opacity-0 transition-opacity duration-1000 ease-in" id="flipbook-section">
            <div class="relative w-full pb-[56.25%] overflow-hidden rounded-xl shadow-2xl border-4 border-gray-300">
                <iframe id="flipbook-iframe" class="absolute top-0 left-0 w-full h-full" allowfullscreen="true" allow="fullscreen" loading="lazy"></iframe>
            </div>
        </div>
    </div>

    <script>
        // --- CUSTOMIZABLE VARIABLES ---
        // Change the name of the recipient here
        const CUSTOMER_NAME = 'Jessica';
        // Paste your AnyFlip embed link here
        const FLIPBOOK_URL = 'https://online.anyflip.com/vaxr/bgyf/html5/';

        document.addEventListener('DOMContentLoaded', () => {
            const loadingScreen = document.getElementById('loading-screen');
            const countdownEl = document.getElementById('countdown');
            const mainContent = document.getElementById('main-content');
            const occasionTitle = document.getElementById('occasion-title');
            const messageCard = document.getElementById('message-card');
            const flipbookSection = document.getElementById('flipbook-section');
            const flipbookIframe = document.getElementById('flipbook-iframe');

            let countdown = 5;

            // Update the title with the customer's name
            occasionTitle.textContent = `Happy Birthday ${CUSTOMER_NAME}!`;
            
            // Set up the countdown animation
            const countdownInterval = setInterval(() => {
                countdown--;
                countdownEl.textContent = countdown;
                countdownEl.classList.remove('number-animation');
                void countdownEl.offsetWidth; // Trigger reflow to restart animation
                countdownEl.classList.add('number-animation');

                if (countdown === 0) {
                    clearInterval(countdownInterval);
                    
                    // Fade out the loading screen
                    loadingScreen.style.opacity = '0';

                    setTimeout(() => {
                        loadingScreen.style.display = 'none';
                        document.body.style.overflow = 'auto'; // Re-enable scrolling

                        // Fade in the main content and reveal the message
                        mainContent.style.opacity = '1';
                        messageCard.classList.remove('translate-y-8', 'opacity-0');
                        messageCard.classList.add('translate-y-0', 'opacity-100');

                        // Set the flipbook source and fade it in
                        setTimeout(() => {
                            flipbookIframe.src = FLIPBOOK_URL;
                            flipbookSection.style.opacity = '1';
                        }, 500); // Small delay for smooth sequencing

                    }, 1000); // Matches the transition duration
                }
            }, 1000); // Countdown every second
        });
    </script>
</body>
</html>

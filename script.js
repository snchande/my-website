document.addEventListener('DOMContentLoaded', () => {
    console.log('Website loaded successfully!');

    // Smooth scroll for nav links
    document.querySelectorAll('nav a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = document.querySelector(link.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // Dark mode toggle
    const toggle = document.getElementById('theme-toggle');
    toggle.addEventListener('click', () => {
        document.body.classList.toggle('dark');
        toggle.textContent = document.body.classList.contains('dark')
            ? '☀️ Light Mode'
            : '🌙 Dark Mode';
    });
});

/**
 * Relationship Diagram SaaS - Script
 * Animations and Interactions
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. スクロールに応じたふわっとした表示 (Intersection Observer)
    const observerOptions = {
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // アニメーションさせたい要素をターゲットにする
    const revealElements = document.querySelectorAll('.feature-card, .section-title, .cta h2, .cta p, .hero-image');
    
    // スタイルシートにアニメーション用のCSSを動的に追加
    const style = document.createElement('style');
    style.textContent = `
        .feature-card, .section-title, .cta h2, .cta p, .hero-image {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.8s ease-out, transform 0.8s ease-out;
        }
        .visible {
            opacity: 1 !important;
            transform: translateY(0) !important;
        }
    `;
    document.head.appendChild(style);

    revealElements.forEach(el => observer.observe(el));

    // 2. スムーズスクロール
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });

    // 3. ヒーローセクションのフェードイン (即座に開始)
    const heroContent = document.querySelector('.hero-content');
    if (heroContent) {
        heroContent.style.opacity = '0';
        heroContent.style.transform = 'translateY(20px)';
        heroContent.style.transition = 'opacity 1s ease-out, transform 1s ease-out';
        
        setTimeout(() => {
            heroContent.style.opacity = '1';
            heroContent.style.transform = 'translateY(0)';
        }, 100);
    }
});

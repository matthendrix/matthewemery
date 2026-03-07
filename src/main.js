import './styles.css';

const app = document.querySelector('#app');

app.innerHTML = `
  <main class="composition" aria-label="Landing page">
    <div class="composition-shell">
      <figure class="image-frame">
        <img src="/this.jpg" alt="" decoding="async" fetchpriority="high" />
      </figure>
    </div>
  </main>
`;

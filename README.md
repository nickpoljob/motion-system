# Motion System — Озон Банк

Сайт-спецификация motion-системы для мобильного банковского приложения. Проект совмещает документацию, playground и каталог анимаций: дизайнеры смотрят принципы и примеры, разработчики копируют токены и CSS-рецепты.

## Источник правды

| Файл | Статус |
|---|---|
| `index.html` | Главный сайт, playground и каталог анимаций |
| `tokens.css` | App-токены: Onest, цвета, типографика, радиусы, отступы |
| `assets/status-bar-*.svg` | SVG-статус-бары для светлого и тёмного состояния превью |
| `spec.md` | Текстовая спецификация, синхронизированная с сайтом |

Удалены устаревшие preview-страницы, временные HTML, логи Playwright и PNG-скриншоты из корня проекта.

## Как запустить

```bash
cd /Users/nikolajpolakov/Desktop/проекты/анимация
python3 -m http.server 8770
```

Открыть:

```text
http://localhost:8770/index.html
```

Полезные маршруты:

| URL | Что смотреть |
|---|---|
| `#principles-full` | Полная спецификация: принципы, токены, правила для разработчиков |
| `#principles` | Playground для duration/easing: curve, position, expand и scale-примеры |
| `#skeleton-loading` | Скелетон: состояние загрузки → раскрытие главного экрана |
| `#button-press` | Анимация кнопки |
| `#card-press` | Анимация карточки — превью на главном экране приложения, карточки интерактивны |
| `#toast` | Toast |
| `#bottom-sheet` | Bottom Sheet |
| `#search-transition` | Search-переход: главный экран → экран поиска по клику на иконку |
| `#push-transition` | Push/Pop-переход: главный экран → второй skeleton-экран |
| `#fullscreen-curtain` | Fullscreen curtain: внешний banner trigger → HTML/CSS-шторка с heart hero и sheet |

## Текущие токены

Motion-токены (`index.html`):

Duration: `xs` 150ms · `s` 240ms · `m` 320ms · `l` 480ms · `xl` 720ms

Easing: `standard` `cubic-bezier(0.55, 0, 0.45, 1)` · `enter` `cubic-bezier(0.12, 1, 0.24, 1)` · `exit` `cubic-bezier(0.64, 0, 0.78, 0)` · `spring` `cubic-bezier(0.42, 0, 0.18, 1.06)`

App-токены (`tokens.css`):

### Типографика — три изолированные системы

Шрифты и размеры сайта живут в `tokens.css`. Захардкоженные `font-family`, `font-size`, `font-weight`, `letter-spacing` запрещены — всё только через токены ниже. Смешивать системы между собой нельзя.

| Подсистема | Префикс | Шрифт | Размеры | Где используется |
|---|---|---|---|---|
| **Site** | `--site-*` | **только Onest** (`--site-font`) | `--site-text-12 / 16 / 20 / 24 / 32` | весь UI документации: sidebar, заголовки, абзацы, кнопки, чипы, лейблы |
| **Code** | `--code-*` | моно (`--code-font`) | `--code-text-12 / 14` | **только** блоки кода (`<pre>`, `<code>`) и инлайн-значения токенов (например `duration-l · ease-spring`) |
| **Phone** | `--phone-*`, `--font-app` | Onest (`--font-app`) | `--phone-size-*`, `--phone-text-*` | **только внутри `.phone-frame`** |

Site-веса: `--site-weight-regular / medium / semibold / bold`. Site line-height: `--site-line-tight / default / relaxed`. Site трекинг: `--site-tracking-display` (крупные числа).

**Правила:**
- На сайте может использоваться только Onest. Других шрифтов быть не должно.
- Размеры на сайте — только из шкалы `12 / 16 / 20 / 24 / 32`.
- Моноширинный шрифт (`--code-*`) **разрешён только в блоках кода** (`<pre>`, `<code>`, code-snippet карточки) и в инлайн-значениях токенов. Эйбрау-лейблы, подписи параметров — это **site**, а не code.
- **CAPS (`text-transform: uppercase`) на сайте запрещён.** Не использовать ни в каких лейблах, эйбрау, метках. Текст набирается в естественном регистре.
- Phone-токены — только внутри `.phone-frame`.

Цвета — поверхности: `#F5F7FA` page · `#FFFFFF` card · `#070707` dark · `rgba(255,255,255,0.16)` white-16 · `rgba(255,255,255,0.30)` white-30.

Цвета — бренд: `#005BFF` primary · `#0096FF` primary-on-dark · `#5B51DE` purple · `#9BF050` lime.

Цвета — статус: `#1DED62` success · `rgba(29,237,98,0.16)` success-bg.

Цвета — оверлеи: `rgba(0,26,52,0.60)` overlay-dark · `rgba(204,214,228,0.60)` border.

Радиусы: 16/14/12px. Отступы: 16/8px.

Phone preview-токены (`index.html`, `.phone-frame`):

Масштаб: дизайн-экран `375 × 812 dp`, ширина внутреннего превью `260px`, коэффициент `260 / 375`.

Размеры внутри телефонных экранов задаются через `--phone-size-*`, например `--phone-size-24: calc(24px * var(--phone-scale))`. Не используй заранее пересчитанные значения вроде `16.64px`, `30.51px` или сырые размеры из макета.

Типографика внутри телефонных экранов задаётся через `--phone-text-*`, например `--phone-text-semibold-16: 600 var(--phone-size-16) / var(--phone-size-20) var(--font-app)`. Не используй `--app-text-*` напрямую внутри phone UI: app-токены не масштабируются.

## Как добавить новую анимацию

1. Открыть `index.html`.
2. Найти массив `ANIMATIONS`.
3. Добавить объект с тем же контрактом, что у текущих рецептов:

```js
{
  id: 'my-animation',
  name: 'Название',
  group: 'feedback', // navigation | overlays | feedback
  description: 'Короткое описание.',
  defaults: { duration: 'm', easing: 'enter' },
  renderPreview(phone) {
    this.reset(phone);
    // Создать элементы в начальном состоянии.
  },
  play(phone, durMs, easeValue) {
    // Запустить transform/opacity transition или WAAPI.
  },
  reset(phone) {
    // Очистить созданные элементы.
  },
  cssTemplate(dur, ease) {
    return `/* CSS-рецепт */`;
  }
}
```

Правило: у компонента один основной motion-рецепт. Core motion строится на `transform` и `opacity`; state styling описывается отдельно.

## Примечания по превью

- Playground (`#principles`) при открытии всегда показывает сброшенное состояние. Кнопка Play запускает четыре демо, а через 3 секунды после конца проигрывания они плавно возвращаются в старт.
- В Playground `expand` меняет реальную высоту при постоянной ширине и `border-radius: 16px`; не используй `scaleY` для этого демо, иначе скругления визуально сплющиваются. Демо `scale, position, opacity` стартует как видимый квадрат около `8 × 8px`.
- Размер телефона в каталоге уменьшен относительно макета. Размеры, отступы, радиусы и шрифты внутри app-preview задаются через `--phone-scale`, `--phone-size-*` и `--phone-text-*`, чтобы соответствовать значениям макета в design-dp.
- Внутри phone UI нельзя смешивать сырые `px`, заранее пересчитанные CSS-пиксели и app-токены типографики. Разрешены phone-токены; технические линии вроде `1px` допустимы только там, где это именно экранная линия, а не размер из макета.
- Статус-бар и home indicator закреплены поверх экранов и не участвуют в push/pop-трансформации. В push-переходе меняется только SVG статус-бара: светлый на главном экране, тёмный на целевом.

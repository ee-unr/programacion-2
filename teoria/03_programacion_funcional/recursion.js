/* Applet autónomo: simula los dos ejemplos fijos, sin ejecutar código del usuario. */
'use strict';

function buildTrace(kind, argument) {
  const max = kind === 'factorial' ? 10 : 7;
  if (!['factorial', 'fibonacci'].includes(kind) || !Number.isInteger(argument) || argument < 0 || argument > max) {
    throw new RangeError('Argumento fuera del rango del ejemplo.');
  }
  const nodes = [], events = [], stack = [];
  const name = kind;
  const call = n => `${name}(${n})`;
  const snapshot = (id, line, title, description) => {
    events.push({id, line, title, description, stack: [...stack], nodes: nodes.map(node => ({...node, children: [...node.children]}))});
  };
  snapshot(null, null, 'Todo listo', `Vamos a calcular ${call(argument)}. Avanzá para realizar la primera llamada.`);
  function visit(n, parent = null, depth = 0) {
    const id = nodes.length;
    const node = {id, n, parent, depth, children: [], status: 'active', value: null, phase: 'call'};
    nodes.push(node);
    if (parent !== null) { nodes[parent].children.push(id); nodes[parent].status = 'waiting'; }
    stack.push(id);
    snapshot(id, 1, `Llamada a ${call(n)}`, `Se crea un contexto nuevo con n = ${n}${parent === null ? '.' : `. ${call(nodes[parent].n)} queda esperando su resultado.`}`);
    node.phase = 'check';
    snapshot(id, 2, '¿Es el caso base?', `Se evalúa n <= 1: ${n} <= 1 es ${n <= 1 ? 'verdadero' : 'falso'}.`);
    if (n <= 1) {
      node.phase = 'base';
      node.value = kind === 'factorial' ? 1 : n;
      node.status = 'returned';
      snapshot(id, 3, `Caso base: devuelve ${node.value}`, `${call(n)} devuelve ${node.value} sin hacer más llamadas. Ese valor vuelve a quien hizo la llamada.`);
    } else {
      node.phase = 'recursive';
      snapshot(id, 5, 'Caso recursivo', kind === 'factorial'
        ? `Para calcular ${n} × ${call(n - 1)}, primero necesitamos el resultado de ${call(n - 1)}. La multiplicación queda pendiente.`
        : `Para calcular ${call(n - 1)} + ${call(n - 2)}, Python evalúa primero la llamada de la izquierda. La suma queda pendiente.`);
      const left = visit(n - 1, id, depth + 1);
      node.status = 'active';
      if (kind === 'fibonacci') {
        snapshot(id, 5, 'Vuelve el primer resultado', `${call(n - 1)} devolvió ${left}. Guardamos ese valor y ahora evaluamos ${call(n - 2)}; todavía no podemos sumar.`);
        const right = visit(n - 2, id, depth + 1);
        node.value = left + right;
      } else node.value = n * left;
      node.status = 'returned';
      const calculation = kind === 'factorial' ? `${n} × ${left}` : node.children.map(child => nodes[child].value).join(' + ');
      snapshot(id, 5, `Retorno: ${calculation} = ${node.value}`, `Ya tenemos los resultados necesarios. ${call(n)} devuelve ${node.value}${parent === null ? '.' : ` a ${call(nodes[parent].n)}.`}`);
    }
    stack.pop();
    return node.value;
  }
  const value = visit(argument);
  snapshot(null, null, `Resultado: ${call(argument)} = ${value}`, 'La llamada inicial terminó. La pila está vacía; en el diagrama quedan todas las llamadas y sus resultados.');
  // Árbol de nodos compacto: separar sólo los niveles que se superponen.
  // Las posiciones son fijas para que avanzar y retroceder conserve el dibujo.
  nodes.forEach(node => {
    const calculation = node.n <= 1 ? 'Caso base'
      : kind === 'factorial' ? `${node.n} × ${nodes[node.children[0]].value} = ${node.value}`
      : `${nodes[node.children[0]].value} + ${nodes[node.children[1]].value} = ${node.value}`;
    node.width = Math.max(96, Math.ceil(calculation.length * 7.2 + 16));
    node.height = 60;
  });
  function arrange(id) {
    const node = nodes[id];
    node.offset = 0;
    if (!node.children.length) return {top: [-node.width/2], bottom: [node.width/2]};
    const branches = node.children.map(arrange);
    if (branches.length === 2) {
      const [left, right] = branches;
      let distance = 16;
      for (let depth = 0; depth < Math.min(left.bottom.length, right.top.length); depth++) {
        distance = Math.max(distance, left.bottom[depth] - right.top[depth] + 16);
      }
      nodes[node.children[0]].offset = -distance / 2;
      nodes[node.children[1]].offset = distance / 2;
    }
    const top = [-node.width/2], bottom = [node.width/2];
    branches.forEach((branch, index) => {
      const offset = nodes[node.children[index]].offset;
      branch.top.forEach((value, depth) => { top[depth+1] = Math.min(top[depth+1] ?? Infinity, value + offset); });
      branch.bottom.forEach((value, depth) => { bottom[depth+1] = Math.max(bottom[depth+1] ?? -Infinity, value + offset); });
    });
    return {top, bottom};
  }
  arrange(0);
  function position(id, across = 0) {
    const node = nodes[id];
    if (kind === 'factorial') {
      node.x = node.parent === null ? node.width/2 + 12
        : nodes[node.parent].x + nodes[node.parent].width/2 + 24 + node.width/2;
      node.y = 44 + node.depth * 20;
    } else {
      node.x = across;
      node.y = 42 + node.depth * 88;
    }
    node.children.forEach(child => position(child, across + nodes[child].offset));
  }
  position(0);
  if (kind === 'fibonacci') {
    const minimum = Math.min(...nodes.map(node => node.x - node.width/2));
    nodes.forEach(node => { node.x += 12 - minimum; });
  }
  return {kind, argument, nodes, events, value,
    width: Math.max(200, Math.max(...nodes.map(node => node.x + node.width/2)) + 12),
    height: Math.max(140, Math.max(...nodes.map(node => node.y)) + 42)};
}

if (typeof module !== 'undefined' && module.exports) module.exports = {buildTrace};

if (typeof document !== 'undefined') {
  const $ = id => document.getElementById(id);
  let trace, step = 0, fit = true;
  const source = {
    factorial: ['def factorial(n):', '    if n <= 1:', '        return 1', '    else:', '        return n * factorial(n - 1)'],
    fibonacci: ['def fibonacci(n):', '    if n <= 1:', '        return n', '    else:', '        return fibonacci(n - 1) + fibonacci(n - 2)']
  };
  const palette = {
    active: {fill: '#eaf2ff', stroke: '#165dc8', label: 'En ejecución'},
    waiting: {fill: '#fff3d0', stroke: '#946000', label: 'En espera'},
    returned: {fill: '#e5f5ed', stroke: '#177451', label: 'Resuelto'}
  };
  function expression(node, visible) {
    if (node.phase === 'call' || node.phase === 'check') return 'valor: ?';
    if (node.n <= 1) return `base → ${node.value}`;
    const values = node.children.map(id => visible[id].value ?? '?');
    return trace.kind === 'factorial' ? `${node.n} × ${values[0] ?? '?'}` : `${values[0] ?? '?'} + ${values[1] ?? '?'}`;
  }
  function svgElement(tag, attrs, content) {
    const element = document.createElementNS('http://www.w3.org/2000/svg', tag);
    Object.entries(attrs).forEach(([key, value]) => element.setAttribute(key, value));
    if (content !== undefined) element.textContent = content;
    return element;
  }
  function draw(event, follow) {
    const svg = $('diagram');
    svg.replaceChildren();
    const viewport = $('viewport');
    const availableHeight = Math.min(window.innerWidth <= 600 ? 340 : 440, Math.max(160, trace.height + 12));
    const scale = fit ? Math.min(1, Math.max(1, viewport.clientWidth - 8) / trace.width, (availableHeight - 8) / trace.height) : 1;
    viewport.style.height = `${fit ? Math.max(160, trace.height * scale + 8) : availableHeight}px`;
    svg.setAttribute('viewBox', `0 0 ${trace.width} ${trace.height}`);
    svg.setAttribute('width', trace.width * scale);
    svg.setAttribute('height', trace.height * scale);
    svg.append(svgElement('title', {id: 'svg-title'}, `Llamadas de ${trace.kind}(${trace.argument})`), svgElement('desc', {id: 'svg-description'}, event.description));
    const defs = svgElement('defs', {});
    for (const [id, color] of [['call-arrow', '#7b8fa3'], ['return-arrow', '#177451']]) {
      const marker = svgElement('marker', {id, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 7, markerHeight: 7, orient: 'auto-start-reverse'});
      marker.append(svgElement('path', {d: 'M 0 0 L 10 5 L 0 10 z', fill: color})); defs.append(marker);
    }
    svg.append(defs);
    for (const node of event.nodes) {
      if (node.parent === null) continue;
      const here = trace.nodes[node.id], parent = trace.nodes[node.parent];
      const returned = node.status === 'returned';
      const start = returned ? here : parent, end = returned ? parent : here;
      const dx = end.x - start.x, dy = end.y - start.y, length = Math.hypot(dx, dy);
      const ux = dx / length, uy = dy / length;
      const boundary = (node, ux, uy) => Math.min(Math.abs(ux) < 1e-9 ? Infinity : node.width/2/Math.abs(ux), Math.abs(uy) < 1e-9 ? Infinity : node.height/2/Math.abs(uy));
      const from = boundary(start, ux, uy), to = boundary(end, ux, uy);
      const x1 = start.x + ux * (from+1), y1 = start.y + uy * (from+1);
      const x2 = end.x - ux * (to+4), y2 = end.y - uy * (to+4);
      svg.append(svgElement('path', {d: `M ${x1} ${y1} L ${x2} ${y2}`, fill: 'none', stroke: returned ? '#177451' : '#7b8fa3', 'stroke-width': node.id === event.id ? 2.5 : 1.7, 'marker-end': `url(#${returned ? 'return-arrow' : 'call-arrow'})`}));
      if (returned) {
        const x = (x1+x2)/2, y = (y1+y2)/2 - (trace.kind === 'factorial' ? 36 : 0);
        const width = Math.max(22, String(node.value).length * 8 + 10);
        svg.append(svgElement('rect', {x: x-width/2, y: y-10, width, height: 20, rx: 5, fill: '#e5f5ed'}), svgElement('text', {x, y: y+4, 'text-anchor': 'middle', fill: '#177451', 'font-size': 12}, node.value));
      }
    }
    for (const node of event.nodes) {
      const position = trace.nodes[node.id], color = palette[node.status];
      const group = svgElement('g', {transform: `translate(${position.x},${position.y})`});
      group.append(svgElement('title', {}, `${trace.kind}(${node.n}) · llamada #${node.id+1} · ${color.label}${node.value === null ? '' : ` · devuelve ${node.value}`}`));
      group.dataset.callId = node.id;
      group.dataset.status = node.status;
      group.append(svgElement('rect', {x: -position.width/2, y: -30, width: position.width, height: 60, rx: 9, fill: color.fill, stroke: color.stroke, 'stroke-width': node.id === event.id ? 3 : 1.5}));
      group.append(svgElement('text', {x: 0, y: -12, 'text-anchor': 'middle', class: 'node-title', fill: '#192b3a'}, `n = ${node.n}`));
      group.append(svgElement('text', {x: 0, y: 4, 'text-anchor': 'middle', class: 'node-state', fill: color.stroke}, color.label));
      const calculation = expression(node, event.nodes) + (node.n > 1 && node.value !== null ? ` = ${node.value}` : '');
      group.append(svgElement('text', {x: 0, y: 22, 'text-anchor': 'middle', class: 'node-detail', fill: '#192b3a'}, calculation));
      svg.append(group);
    }
    if (!event.nodes.length) svg.append(svgElement('text', {x: trace.width/2, y: 100, 'text-anchor': 'middle', fill: '#566879', 'font-size': 14}, 'Avanzá para iniciar el diagrama.'));
    if (follow && event.id !== null) {
      const node = trace.nodes[event.id];
      const x = node.x * scale, y = node.y * scale;
      if (x-node.width/2*scale < viewport.scrollLeft || x+node.width/2*scale > viewport.scrollLeft+viewport.clientWidth) viewport.scrollLeft = x-viewport.clientWidth/2;
      if (y-30*scale < viewport.scrollTop || y+30*scale > viewport.scrollTop+viewport.clientHeight) viewport.scrollTop = y-viewport.clientHeight/2;
    }
  }
  function render(follow = true) {
    const event = trace.events[step];
    $('code').replaceChildren();
    source[trace.kind].forEach((text, index) => {
      const line = document.createElement('div'); line.className = 'code-line' + (index+1 === event.line ? ' current' : '');
      if (index+1 === event.line) line.setAttribute('aria-current', 'step');
      const number = document.createElement('span'); number.className = 'line-number'; number.textContent = index+1;
      const code = document.createElement('span'); code.textContent = text;
      line.append(number, code); $('code').append(line);
    });
    $('stack').replaceChildren();
    if (!event.stack.length) {
      const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = step === 0 ? 'Todavía no hay llamadas.' : 'Pila vacía: ejecución terminada.'; $('stack').append(empty);
    }
    [...event.stack].reverse().forEach((id, index) => {
      const node = event.nodes[id], frame = document.createElement('div');
      frame.className = 'frame' + (index === 0 ? (node.status === 'returned' ? ' returning' : ' active') : '');
      const title = document.createElement('strong'); title.textContent = `${trace.kind}(${node.n}) · #${id+1}`;
      const detail = document.createElement('small'); detail.textContent = `n = ${node.n} · ${index === 0 ? (node.status === 'returned' ? `devolviendo ${node.value}` : 'en ejecución') : `espera ${expression(node, event.nodes)}`}`;
      frame.append(title, detail); $('stack').append(frame);
    });
    $('event-title').textContent = event.title; $('event-description').textContent = event.description;
    $('step-count').textContent = `Paso ${step} de ${trace.events.length-1}`;
    $('timeline').max = trace.events.length-1; $('timeline').value = step;
    $('timeline').style.setProperty('--progress', `${100 * step / (trace.events.length-1)}%`);
    $('first').disabled = $('previous').disabled = step === 0;
    $('last').disabled = $('next').disabled = step === trace.events.length-1;
    $('result').textContent = step === trace.events.length-1 ? `Resultado: ${trace.value}` : '';
    draw(event, follow);
  }
  function go(target) { step = Math.max(0, Math.min(trace.events.length-1, target)); render(); }
  function updateLimit() {
    const fib = $('example').value === 'fibonacci'; $('argument').max = fib ? 7 : 10;
    $('limit').textContent = fib ? 'Enteros de 0 a 7, para que el árbol sea legible.' : 'Enteros de 0 a 10.';
  }
  function start() {
    const kind = $('example').value, raw = $('argument').value, n = Number(raw);
    if (raw === '' || !Number.isInteger(n) || n < 0 || n > Number($('argument').max)) {
      $('error').textContent = `Ingresá un entero entre 0 y ${$('argument').max}.`; return;
    }
    $('error').textContent = ''; trace = buildTrace(kind, n); step = 0;
    $('diagram-title').textContent = 'Árbol de llamadas';
    $('diagram-note').textContent = kind === 'factorial'
      ? 'Cada nodo muestra n, su estado y el cálculo parcial. ? indica que todavía falta el resultado de otra llamada.'
      : 'Primero se resuelve la rama izquierda (n − 1). Su valor queda visible mientras se evalúa la derecha (n − 2); ? indica un resultado pendiente.';
    $('viewport').scrollLeft = $('viewport').scrollTop = 0; render(false);
  }
  $('settings').addEventListener('submit', event => { event.preventDefault(); start(); });
  $('argument').addEventListener('input', () => { $('error').textContent = ''; });
  $('example').addEventListener('change', () => { updateLimit(); if (Number($('argument').value) > Number($('argument').max)) $('argument').value = $('argument').max; start(); });
  $('first').addEventListener('click', () => go(0)); $('previous').addEventListener('click', () => go(step-1));
  $('next').addEventListener('click', () => go(step+1)); $('last').addEventListener('click', () => go(trace.events.length-1));
  $('timeline').addEventListener('input', () => go(Number($('timeline').value)));
  $('fit').addEventListener('click', () => { fit = !fit; $('fit').setAttribute('aria-pressed', String(fit)); $('fit').textContent = fit ? 'Tamaño original' : 'Ajustar diagrama'; draw(trace.events[step], true); });
  document.addEventListener('keydown', event => {
    if (['INPUT','SELECT','TEXTAREA','BUTTON'].includes(event.target.tagName) || event.altKey || event.ctrlKey || event.metaKey) return;
    if (event.key === 'ArrowRight' || event.key === 'ArrowLeft') { event.preventDefault(); go(step+(event.key === 'ArrowRight' ? 1 : -1)); }
  });
  new ResizeObserver(() => draw(trace.events[step], false)).observe($('viewport'));
  updateLimit(); start();
}

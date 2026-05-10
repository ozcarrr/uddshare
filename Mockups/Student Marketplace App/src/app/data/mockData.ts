export interface Product {
  id: string;
  title: string;
  description: string;
  price: number;
  category: string;
  faculty: string;
  course: string;
  condition: string;
  seller: string;
  image: string;
  datePosted: string;
}

export interface Note {
  id: string;
  title: string;
  course: string;
  faculty: string;
  description: string;
  author: string;
  downloads: number;
  rating: number;
  dateUploaded: string;
  fileType: string;
}

export const faculties = [
  "Medicina",
  "Ingeniería",
  "Arquitectura y Arte",
  "Comunicaciones",
  "Derecho",
  "Economía y Negocios",
  "Psicología",
  "Diseño",
];

export const products: Product[] = [
  {
    id: "1",
    title: "Canon EOS Rebel T7 - Cámara para curso de Cine",
    description: "Cámara profesional usada solo un semestre para el curso de Introducción al Cine. Incluye lente 18-55mm, batería extra y tarjeta SD 64GB. En perfectas condiciones.",
    price: 280000,
    category: "Electrónica",
    faculty: "Comunicaciones",
    course: "Introducción al Cine",
    condition: "Como nueva",
    seller: "María González",
    image: "https://images.unsplash.com/photo-1606510815390-aa67f5199102?w=800",
    datePosted: "2026-04-10",
  },
  {
    id: "2",
    title: "Kit Completo de Microscopio para Medicina",
    description: "Set de laboratorio completo con microscopio óptico, portaobjetos, cubreobjetos y soluciones de tinción. Usado solo para el primer año de Medicina.",
    price: 150000,
    category: "Material de Laboratorio",
    faculty: "Medicina",
    course: "Histología I",
    condition: "Muy bueno",
    seller: "Pedro Martínez",
    image: "https://images.unsplash.com/photo-1530210124550-912dc1381cb8?w=800",
    datePosted: "2026-04-12",
  },
  {
    id: "3",
    title: "Set de Instrumentos de Dibujo Técnico",
    description: "Compás profesional, escuadras, regla T, transportador y más. Perfecto para cursos de dibujo arquitectónico. Marca Staedtler.",
    price: 35000,
    category: "Material de Dibujo",
    faculty: "Arquitectura y Arte",
    course: "Taller de Dibujo",
    condition: "Excelente",
    seller: "Ana Silva",
    image: "https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=800",
    datePosted: "2026-04-08",
  },
  {
    id: "4",
    title: "Osciloscopio Digital para Electrónica",
    description: "Osciloscopio digital Rigol DS1054Z, 4 canales, 50 MHz. Usado un semestre para curso de Circuitos Electrónicos. Funciona perfectamente.",
    price: 420000,
    category: "Electrónica",
    faculty: "Ingeniería",
    course: "Circuitos Electrónicos",
    condition: "Como nuevo",
    seller: "Carlos Rojas",
    image: "https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=800",
    datePosted: "2026-04-14",
  },
  {
    id: "5",
    title: "Maqueta de Anatomía Humana Completa",
    description: "Modelo anatómico 3D del torso humano con órganos removibles. Ideal para cursos de anatomía. 85cm de altura.",
    price: 195000,
    category: "Material de Laboratorio",
    faculty: "Medicina",
    course: "Anatomía Humana",
    condition: "Muy bueno",
    seller: "Laura Fernández",
    image: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800",
    datePosted: "2026-04-09",
  },
  {
    id: "6",
    title: "Tableta Wacom Intuos Pro para Diseño",
    description: "Tableta digitalizadora profesional, tamaño mediano. Perfecta para cursos de ilustración digital y diseño gráfico. Incluye lápiz y puntas de repuesto.",
    price: 220000,
    category: "Electrónica",
    faculty: "Diseño",
    course: "Ilustración Digital",
    condition: "Excelente",
    seller: "Sofía Vargas",
    image: "https://images.unsplash.com/photo-1616469829941-2a94b6b9e446?w=800",
    datePosted: "2026-04-11",
  },
  {
    id: "7",
    title: "Libros de Derecho Civil I, II y III",
    description: "Set completo de 3 tomos de Derecho Civil. Edición 2024, como nuevos con marcadores incluidos. Ahorra en comprar nuevos.",
    price: 95000,
    category: "Libros",
    faculty: "Derecho",
    course: "Derecho Civil",
    condition: "Como nuevo",
    seller: "Diego Morales",
    image: "https://images.unsplash.com/photo-1589998059171-988d887df646?w=800",
    datePosted: "2026-04-13",
  },
  {
    id: "8",
    title: "Calculadora Financiera HP 12C",
    description: "Calculadora financiera programable HP 12C Gold. Imprescindible para cursos de finanzas y valoración. Incluye manual y estuche.",
    price: 85000,
    category: "Electrónica",
    faculty: "Economía y Negocios",
    course: "Finanzas Corporativas",
    condition: "Muy bueno",
    seller: "Valentina López",
    image: "https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=800",
    datePosted: "2026-04-07",
  },
];

export const notes: Note[] = [
  {
    id: "1",
    title: "Apuntes Completos Cálculo I - 2025",
    course: "Cálculo I",
    faculty: "Ingeniería",
    description: "Apuntes completos del curso con todos los teoremas, demostraciones y ejercicios resueltos. Incluye preparación para todas las evaluaciones.",
    author: "Matías Pérez",
    downloads: 247,
    rating: 4.8,
    dateUploaded: "2026-03-15",
    fileType: "PDF",
  },
  {
    id: "2",
    title: "Resumen Anatomía Humana - Sistema Nervioso",
    course: "Anatomía Humana",
    faculty: "Medicina",
    description: "Resumen detallado del sistema nervioso con diagramas y esquemas. Incluye nervios craneales, médula espinal y encéfalo.",
    author: "Camila Torres",
    downloads: 198,
    rating: 4.9,
    dateUploaded: "2026-03-28",
    fileType: "PDF",
  },
  {
    id: "3",
    title: "Guía de Estudio Derecho Constitucional",
    course: "Derecho Constitucional",
    faculty: "Derecho",
    description: "Guía completa con casos prácticos, jurisprudencia relevante y esquemas para entender los conceptos clave del curso.",
    author: "Felipe Reyes",
    downloads: 156,
    rating: 4.6,
    dateUploaded: "2026-04-02",
    fileType: "PDF",
  },
  {
    id: "4",
    title: "Apuntes Psicología del Desarrollo",
    course: "Psicología del Desarrollo",
    faculty: "Psicología",
    description: "Notas de clase completas con teorías de Piaget, Erikson, Vygotsky y otros autores importantes. Incluye ejemplos prácticos.",
    author: "Josefina Castro",
    downloads: 132,
    rating: 4.7,
    dateUploaded: "2026-03-20",
    fileType: "PDF",
  },
  {
    id: "5",
    title: "Formulario Completo Física I",
    course: "Física I",
    faculty: "Ingeniería",
    description: "Formulario con todas las ecuaciones importantes organizadas por tema: cinemática, dinámica, trabajo y energía, momento lineal.",
    author: "Rodrigo Muñoz",
    downloads: 289,
    rating: 5.0,
    dateUploaded: "2026-03-10",
    fileType: "PDF",
  },
  {
    id: "6",
    title: "Apuntes Historia del Arte Contemporáneo",
    course: "Historia del Arte",
    faculty: "Arquitectura y Arte",
    description: "Resumen completo desde el Impresionismo hasta el arte contemporáneo. Incluye imágenes de obras importantes y contexto histórico.",
    author: "Javiera Soto",
    downloads: 94,
    rating: 4.5,
    dateUploaded: "2026-04-05",
    fileType: "PDF",
  },
  {
    id: "7",
    title: "Ejercicios Resueltos Microeconomía",
    course: "Microeconomía",
    faculty: "Economía y Negocios",
    description: "Más de 50 ejercicios resueltos paso a paso sobre oferta, demanda, elasticidad, teoría del consumidor y teoría del productor.",
    author: "Benjamín Herrera",
    downloads: 221,
    rating: 4.9,
    dateUploaded: "2026-03-25",
    fileType: "PDF",
  },
  {
    id: "8",
    title: "Resumen Semiótica y Comunicación",
    course: "Semiótica",
    faculty: "Comunicaciones",
    description: "Apuntes de Saussure, Peirce y Barthes. Incluye análisis de casos y ejemplos aplicados a la comunicación visual y audiovisual.",
    author: "Isidora Núñez",
    downloads: 87,
    rating: 4.4,
    dateUploaded: "2026-04-01",
    fileType: "PDF",
  },
  {
    id: "9",
    title: "Apuntes Teoría del Color - Diseño",
    course: "Teoría del Color",
    faculty: "Diseño",
    description: "Apuntes completos sobre círculo cromático, armonías, psicología del color y aplicaciones en diseño. Incluye paletas de ejemplo.",
    author: "Martina Bravo",
    downloads: 165,
    rating: 4.8,
    dateUploaded: "2026-03-18",
    fileType: "PDF",
  },
  {
    id: "10",
    title: "Resumen Farmacología Básica",
    course: "Farmacología",
    faculty: "Medicina",
    description: "Resumen de los principales grupos farmacológicos, mecanismos de acción, efectos adversos y contraindicaciones.",
    author: "Sebastián Campos",
    downloads: 203,
    rating: 4.7,
    dateUploaded: "2026-03-22",
    fileType: "PDF",
  },
];

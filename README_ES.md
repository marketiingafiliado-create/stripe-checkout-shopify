# Stripe Checkout (Ruby) -> Botón en Shopify

Este proyecto crea una **Stripe Checkout Session** en un servidor Ruby (Sinatra) y redirige al pago.

## 1) Variables de entorno (OBLIGATORIAS)

- `STRIPE_SECRET_KEY` = tu secret key de Stripe (NO la pegues aquí, ponla como env var en tu host)
- `STRIPE_PRICE_ID` = el Price ID de tu producto en Stripe (ej: `price_123...`)
- `APP_DOMAIN` = el dominio donde corre este servidor (ej: `https://tu-app.onrender.com`)

Opcionales:
- `SUCCESS_URL` (default: `APP_DOMAIN/success.html`)
- `CANCEL_URL` (default: `APP_DOMAIN/cancel.html`)

## 2) Endpoint para Shopify

Usa esta URL:

`https://TU_APP/pay?qty=1&shop=TU_SHOP&product=HANDLE&variant=VARIANT_ID`

## 3) Botón (Custom liquid) en Shopify

Pega esto donde quieras el botón:

```liquid
<a class="button button--primary" style="width:100%;text-align:center;margin-top:10px;"
   href="https://TU_APP/pay?qty=1&shop={{ shop.permanent_domain }}&product={{ product.handle }}&variant={{ product.selected_or_first_available_variant.id }}">
  Comprar con Stripe
</a>
```

## Nota
Esto **no crea** una orden en Shopify automáticamente. Es un pago externo en Stripe.

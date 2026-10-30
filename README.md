# Infraestructura mínima en AWS — Solo 1 VPC (Terraform)

Proyecto de demostración para el curso **Ethical Hacking y Seguridad (ESAN)**.
Despliega la infraestructura **más mínima posible**: una única VPC básica, sin
subredes, sin internet gateway, sin NAT. Equivale a elegir **"Solo la VPC"** en
la consola de AWS.

## ¿Qué crea?

| Recurso        | Valor por defecto | Equivalente en la consola         |
|----------------|-------------------|-----------------------------------|
| VPC            | `my-vpc-01`       | Etiqueta de nombre                |
| CIDR IPv4      | `10.0.0.0/24`     | Bloque de CIDR IPv4 (256 IPs)     |
| IPv6           | ninguno           | Sin bloque de CIDR IPv6           |
| Tenencia       | `default`         | Predeterminado                    |

> No habilita el "Control de cifrado de VPC". Es un buen ejercicio pedirle a
> los alumnos que lo activen en modo supervisión y comparen el plan.

## Estructura

```
.
├── main.tf                     # Provider + recurso aws_vpc
├── variables.tf                # Región, nombre y CIDR (con validación /16–/28)
├── outputs.tf                  # vpc_id, cidr, arn
├── terraform.tfvars.example    # Plantilla de variables (copiar a terraform.tfvars)
├── .gitignore                  # Ignora state, .terraform y secretos
└── .github/workflows/terraform.yml  # CI/CD: plan en PR, apply en main
```

## Uso local

```bash
# 1. Clona el repo y entra a la carpeta
cd terraform-vpc-minimo

# 2. (Opcional) copia la plantilla de variables
cp terraform.tfvars.example terraform.tfvars   # edita si quieres otros valores

# 3. Configura tus credenciales de AWS (una de estas vías)
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="us-east-1"

# 4. Inicializa, revisa y aplica
terraform init
terraform plan
terraform apply

# 5. Para destruir todo cuando termines (evita cargos)
terraform destroy
```

## Despliegue automático con GitHub Actions

El workflow `.github/workflows/terraform.yml`:

- En cada **Pull Request** a `main`: corre `fmt`, `validate` y `plan` (no aplica).
- En **push a `main`** (o lanzamiento manual desde *Actions*): ejecuta `apply`.

### Secretos que debes crear en el repo

En GitHub: **Settings → Secrets and variables → Actions → New repository secret**

| Secreto                  | Descripción                        |
|--------------------------|------------------------------------|
| `AWS_ACCESS_KEY_ID`      | Access key de un usuario IAM       |
| `AWS_SECRET_ACCESS_KEY`  | Secret key de ese usuario IAM      |

> **Nota de seguridad (para el curso):** lo ideal no son claves de acceso
> estáticas sino **OIDC con un rol IAM** (`role-to-assume`), que evita guardar
> secretos de larga duración. Este ejemplo usa claves por simplicidad; migrar a
> OIDC es un excelente ejercicio de endurecimiento.

## Costo

Una VPC vacía **no genera costo**. El cobro aparece con NAT gateways, IPs
elásticas sin usar, instancias, etc. Aun así, corre `terraform destroy` al
terminar la práctica.

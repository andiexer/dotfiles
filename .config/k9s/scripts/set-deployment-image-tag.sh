#!/usr/bin/env bash

set -euo pipefail

name="${1:?deployment name is required}"
namespace="${2:?namespace is required}"
context="${3:-}"

clear

kubectl_args=()
if [[ -n "$context" ]]; then
  kubectl_args+=(--context "$context")
fi

containers=()
while IFS= read -r line; do
  containers+=("$line")
done < <(
  kubectl "${kubectl_args[@]}" get deployment "$name" -n "$namespace" \
    -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\t"}{.image}{"\n"}{end}'
)

if [[ "${#containers[@]}" -eq 0 ]]; then
  gum style --foreground 196 "No containers found on deployment/$name in namespace $namespace."
  exit 1
fi

selected_name=""
selected_image=""

if [[ "${#containers[@]}" -eq 1 ]]; then
  IFS=$'\t' read -r selected_name selected_image <<<"${containers[0]}"
else
  container_names=()
  for entry in "${containers[@]}"; do
    IFS=$'\t' read -r container_name _ <<<"$entry"
    container_names+=("$container_name")
  done

  selected_name=$(gum choose --header "Select container on deployment/$name:" "${container_names[@]}")

  for entry in "${containers[@]}"; do
    IFS=$'\t' read -r container_name container_image <<<"$entry"
    if [[ "$container_name" == "$selected_name" ]]; then
      selected_image="$container_image"
      break
    fi
  done
fi

image_without_digest="${selected_image%@*}"
last_segment="${image_without_digest##*/}"
if [[ "$last_segment" == *:* ]]; then
  image_repo="${image_without_digest%:*}"
else
  image_repo="$image_without_digest"
fi

gum style \
  "Deployment: $(gum style --foreground 33 "deployment/$name")" \
  "Namespace : $(gum style --foreground 33 "$namespace")" \
  "Container : $(gum style --foreground 33 "$selected_name")" \
  "Current   : $(gum style --foreground 214 "$selected_image")"

requested_value=$(gum input --placeholder "new tag or full image" --header "New image tag for $selected_name")

if [[ -z "$requested_value" ]]; then
  gum style --foreground 214 "No value entered. Aborting."
  exit 0
fi

if [[ "$requested_value" == *"/"* || "$requested_value" == *"@"* ]]; then
  new_image="$requested_value"
else
  new_image="${image_repo}:${requested_value}"
fi

gum style "Updating $(gum style --foreground 33 "$selected_name") → $(gum style --foreground 82 "$new_image")"

if ! gum confirm "Apply change?"; then
  gum style --foreground 214 "Aborted."
  exit 0
fi

kubectl "${kubectl_args[@]}" set image "deployment/$name" \
  "$selected_name=$new_image" \
  -n "$namespace"

gum style --foreground 82 "Image updated successfully."

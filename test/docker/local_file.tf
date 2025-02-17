resource "local_file" "existing_file" {
  content  = "This content is already existing"
  filename = "${path.module}/local_file/existing_file.txt"
}

# resource "local_file" "file_to_delete" {
#   content  = "This file expected to be deleted"
#   filename = "${path.module}/local_file/file_to_delete.txt"
# }

resource "local_file" "file_to_update" {
  content  = "This file expected to be updated"
  filename = "${path.module}/local_file/file_to_update.txt"
  file_permission = "0700"
}
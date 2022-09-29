load("@ytt:data", "data")
load("@ytt:assert", "assert")

###########
# GENERAL #
###########

def param(key):
  if not key in data.values.params:
    return None
  end
  return data.values.params[key]
end

def merge_annotations(fixed_values):
  annotations = {}
  if type(param("annotations")) == "dict" or type(param("annotations")) == "struct":
    annotations.update(param("annotations"))
  end
  annotations.update(fixed_values)
  return annotations
end

def merge_labels(fixed_values):
  labels = {}
  if hasattr(data.values.deliverable.metadata, "labels"):
    labels.update(data.values.deliverable.metadata.labels)
  end
  labels.update(fixed_values)
  return labels
end

#########
# IMAGE #
#########

def image():
  return image_name("","")
end

def image_bundle():
  return image_name("bundle", ":" + data.values.workload.metadata.uid)
end

def image_name(suffix,tag):
  return "/".join([
    data.values.params.registry.server,
    data.values.params.registry.repository,
    "-".join([
      data.values.workload.metadata.name,
      data.values.workload.metadata.namespace,
      suffix,
    ])
  ]) + tag
end

##########
# GITOPS #
##########

def is_gitops():
  if 'gitops_server_address' in data.values.params and 'gitops_repository_owner' in data.values.params and 'gitops_repository_name' in data.values.params:
    return True
  end
  if 'gitops_server_address' in data.values.params or 'gitops_repository_owner' in data.values.params or 'gitops_repository_name' in data.values.params:
    'gitops_server_address' in data.values.params or assert.fail("missing param: gitops_server_address")
    'gitops_repository_owner' in data.values.params or assert.fail("missing param: gitops_repository_owner")
    'gitops_repository_name' in data.values.params or assert.fail("missing param: gitops_repository_name")
  end
  return False
end

def strip_trailing_slash(some_string):
  if some_string[-1] == "/":
    return some_string[:-1]
  end
  return some_string
end

def git_repository():
  strip_trailing_slash(data.values.params.gitops_server_address)
  return "/".join([
    strip_trailing_slash(data.values.params.gitops_server_address),
    strip_trailing_slash(data.values.params.gitops_repository_owner),
    data.values.params.gitops_repository_name,
  ]) + ".git"
end

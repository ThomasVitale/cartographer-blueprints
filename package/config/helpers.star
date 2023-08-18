load("@ytt:assert", "assert")
load("@ytt:data", "data")

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
  if hasattr(data.values.workload.metadata, "labels"):
    labels.update(data.values.workload.metadata.labels)
  end
  labels.update(fixed_values)
  return labels
end

#########
# IMAGE #
#########

def image():
  return "/".join([
   data.values.params.registry.server,
   data.values.params.registry.repository,
   "-".join([
     data.values.workload.metadata.name,
     data.values.workload.metadata.namespace,
   ])
  ])
end

def oci_bundle():
  return "/".join([
   data.values.params.registry.server,
   data.values.params.registry.repository,
   "-".join([
     data.values.workload.metadata.name,
     data.values.workload.metadata.namespace,
     "bundle",
   ])
  ]) + ":" + data.values.workload.metadata.uid
end

##########
# GITOPS #
##########

def is_gitops_enabled():
  if param("gitops")["strategy"] == "none":
    return False
  end
  if 'server_address' in param("gitops") or 'repository.owner' in param("gitops") or 'repository.name' in param("gitops"):
    'server_address' in param("gitops") or assert.fail("missing param: gitops.server_address")
    'owner' in param("gitops")["repository"] or assert.fail("missing param: gitops.repository.owner")
    'name' in param("gitops")["repository"] or assert.fail("missing param: gitops.repository.name")
  end
  return True
end

def strip_trailing_slash(some_string):
  if some_string[-1] == "/":
    return some_string[:-1]
  end
  return some_string
end

def git_repository():
  strip_trailing_slash(data.values.params.gitops.server_address)
  return "/".join([
    strip_trailing_slash(data.values.params.gitops.server_address),
    strip_trailing_slash(data.values.params.gitops.repository.owner),
    data.values.params.gitops.repository.name,
  ]) + ".git"
end

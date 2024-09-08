# import sys
# import json
# from googleapiclient import discovery
# from google.auth import default

# def get_instances_with_tag(project, tag_key, tag_value):
#     instances = []
#     credentials, _ = default()
#     service = discovery.build('compute', 'v1', credentials=credentials)

#     request = service.instances().aggregatedList(project=project)
#     while request is not None:
#         response = request.execute()
#         for _, instances_scoped_list in response['items'].items():
#             for instance in instances_scoped_list.get('instances', []):
#                 labels = instance.get('labels', {})
#                 if labels.get(tag_key) == tag_value:
#                     instances.append(instance['id'])
#         request = service.instances().aggregatedList_next(previous_request=request, previous_response=response)
    
#     return instances

# if __name__ == "__main__":
#     project = sys.argv[1]
#     tag_key = sys.argv[2]
#     tag_value = sys.argv[3]

#     instances = get_instances_with_tag(project, tag_key, tag_value)
#     # Convert list of instances to a map with keys as "instance_<index>"
#     instances_dict = {f"instance_{i}": instance for i, instance in enumerate(instances)}
#     print(json.dumps(instances_dict))



import sys
import json
from googleapiclient import discovery
from google.auth import default

def get_resources_with_tag(service_name, version, project, tag_key, tag_value, resource_type, resource_key):
    resources = []
    credentials, _ = default()
    service = discovery.build(service_name, version, credentials=credentials)

    if service_name == "compute":
        request = service.instances().aggregatedList(project=project)
        while request is not None:
            response = request.execute()
            for _, instances_scoped_list in response['items'].items():
                for instance in instances_scoped_list.get('instances', []):
                    labels = instance.get('labels', {})
                    if labels.get(tag_key) == tag_value:
                        resources.append(instance['id'])
            request = service.instances().aggregatedList_next(previous_request=request, previous_response=response)

    elif service_name == "composer":
        request = service.projects().locations().environments().list(parent=f'projects/{project}/locations/-')
        while request is not None:
            response = request.execute()
            for environment in response.get('environments', []):
                labels = environment.get('labels', {})
                if labels.get(tag_key) == tag_value:
                    resources.append(environment['name'])
            request = service.projects().locations().environments().list_next(previous_request=request, previous_response=response)

    elif service_name == "storage":
        request = service.buckets().list(project=project)
        while request is not None:
            response = request.execute()
            for bucket in response.get('items', []):
                labels = bucket.get('labels', {})
                if labels.get(tag_key) == tag_value:
                    resources.append(bucket['name'])
            request = service.buckets().list_next(previous_request=request, previous_response=response)

    return resources

if __name__ == "__main__":
    service_name = sys.argv[1]
    version = sys.argv[2]
    project = sys.argv[3]
    tag_key = sys.argv[4]
    tag_value = sys.argv[5]
    resource_type = sys.argv[6]
    resource_key = sys.argv[7]

    resources = get_resources_with_tag(service_name, version, project, tag_key, tag_value, resource_type, resource_key)
    # Convert list of resources to a map with keys as "resource_<index>"
    resources_dict = {f"resource_{i}": resource for i, resource in enumerate(resources)}
    print(json.dumps(resources_dict))

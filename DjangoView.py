from django.forms.models import model_to_dict
from rest_framework import status, permissions
from LLApi.utils.ll_api_view import LLAPIView
from profiles.models import BasicProfile
from oauth2_provider.contrib.rest_framework import TokenHasScope
from .forms.modify_avatar import AvatarForm
import logging

class ModifyAvatar(LLAPIView):
  permission_classes = [permissions.IsAuthenticated, TokenHasScope]
  required_scopes = ['profile_admin']

  def post(self, request):
    avatar_form = AvatarForm(request)
    logger = logging.getLogger(__name__)

    if avatar_form.is_valid():
      sanitized_data = avatar_form.cleaned_data
      profile = BasicProfile.objects.get(id=sanitized_data['profile_id'])
      
      if profile.avatar is not None:
        profile.images.extend([profile.avatar])

      profile.avatar = sanitized_data['avatar']
      profile.save()

      return self.api_response({
        'name': sanitized_data['avatar']
      }, 201, 201, 'Avatar added')
    
    errors = {field: avatar_form.errors[field][0] for field in avatar_form.errors}
    logger.debug(str(errors))
    return self.api_response(errors, status.HTTP_400_BAD_REQUEST, status.HTTP_400_BAD_REQUEST, 'Invalid data')

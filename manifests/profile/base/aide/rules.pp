
class tripleo::profile::base::aide::aide::rules (
  $step = hiera('step'),
  $content='',
  $order=10,
) {

  include ::tripleo::profile::base::aide
  if $content == '' {
      $body = $name
    } else {
      $body = $content
    }

    if (!is_numeric($order) and !is_string($order))
    {
      fail('$order must be a string or an integer')
    }
    validate_string($body)

    concat::fragment{ "aide_fragment_${name}":
      target  => 'aide.conf',
      order   => $order,
      content => $body,
    }
  }
}

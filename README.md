krakenize
=========

Adds some methods to `ActiveRecord::Base` to support `Kraken` models.

### Installation

Include the gem in your Gemfile:

```
gem 'krakenize', :git => 'git://github.com/justintv/krakenize.git'
```

#### `kraken_model?`

Returns `true` if the class is a Kraken model, `false` otherwise.

```ruby
Hydralisk.kraken_model? # false
Kraken::Hydralisk.kraken_model? # true
```

#### `to_kraken`

Returns the `Kraken` equivalent of a class, if one exists.

```ruby
class Zergling < ActiveRecord::Base
end

class Kraken::Zergling < Zergling
end

class Terran < ActiveRecord::Base
end

Zergling.to_kraken # Kraken::Zergling
Kraken::Zergling.to_kraken # Kraken::Zergling
Terran.to_kraken # Terran
```

#### `krakenize_association`

Given an association on a regular ActiveRecord model, this allows you to
transfer the association to a Kraken subclass without rewriting the association
and having to maintain it in two places.

```ruby
class Hatchery < ActiveRecord::Base
  has_many :overlords
end

class Kraken::Hatchery < Hatchery
end

class Overlord < ActiveRecord::Base
end

class Kraken::Overlord < ActiveRecord::Base
end

hatchery = Kraken::Hatchery.first

# returns plain old `Overlord` objects (and not `Kraken::Overlord` objects).
hatchery.overlords

# How do you fix this? Use `krakenize_association`:
class Kraken::Hatchery < Hatchery
  krakenize_association :overlords
end

hatchery.overlords # Now, we return Kraken::Overlord objects.
```

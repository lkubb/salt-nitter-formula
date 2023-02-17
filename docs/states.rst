Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``nitter``
^^^^^^^^^^
*Meta-state*.

This installs the nitter, redis containers,
manages their configuration and starts their services.


``nitter.package``
^^^^^^^^^^^^^^^^^^
Installs the nitter, redis containers only.
This includes creating systemd service units.


``nitter.config``
^^^^^^^^^^^^^^^^^
Manages the configuration of the nitter, redis containers.
Has a dependency on `nitter.package`_.


``nitter.service``
^^^^^^^^^^^^^^^^^^
Starts the nitter, redis container services
and enables them at boot time.
Has a dependency on `nitter.config`_.


``nitter.clean``
^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``nitter`` meta-state
in reverse order, i.e. stops the nitter, redis services,
removes their configuration and then removes their containers.


``nitter.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the nitter, redis containers
and the corresponding user account and service units.
Has a depency on `nitter.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``nitter.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the nitter, redis containers
and has a dependency on `nitter.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``nitter.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Stops the nitter, redis container services
and disables them at boot time.



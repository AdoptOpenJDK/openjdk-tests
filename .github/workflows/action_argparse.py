import argparse
import json
import sys

def map_platforms(platforms):
  """ Takes in a list of platforms and translates Grinder platorms to corresponding GitHub-hosted runners.
      This function both modifies and returns the 'platforms' argument.
  """

  platform_map = {
    'x86-64_windows': 'windows-latest',
    'x86-64_mac': 'mac-latest',
    'x86-64_linux': 'ubuntu-latest'
  }

  for i, platform in enumerate(platforms):
    if platform in platform_map:
        platforms[i] = platform_map[platform]

  return platforms

def main():

    keyword = 'action'

    # We assume the first two elements of sys.argv are the name of this python script and the command keyword respectively
    # e.g.: [ 'action_argparse.py', 'action', ... ]
    raw_args = sys.argv[2:]
    assert sys.argv[1] == keyword

    parser = argparse.ArgumentParser(prog=keyword, add_help=False)
    # Improvement: Automatically resolve the valid choices for each argument populate them below, rather than hard-coding choices.
    parser.add_argument('--sdk_resource', default=['nightly'], choices=['nightly', 'releases'], nargs='+')
    parser.add_argument('--build_list', default=['openjdk'], choices=['openjdk', 'functional', 'system', 'perf', 'external'], nargs='+')
    parser.add_argument('--target', default=['jdk_math'], nargs='+')
    parser.add_argument('--platform', default=['x86-64_linux'], nargs='+')
    parser.add_argument('--jdk_version', default=['8'], nargs='+')
    parser.add_argument('--jdk_impl', default=['openj9'], nargs='+')
    args = parser.parse_args(raw_args)

    output = {
      'sdk_resource': args.sdk_resource,
      'build_list': args.build_list,
      'target': args.target,
      'platform': map_platforms(args.platform),
      'jdk_version': args.jdk_version,
      'jdk_impl': args.jdk_impl
    }
    # Set parameters as output: As JSON, and each item individually
    print('::set-output name=build_parameters::{}'.format(json.dumps(output)))
    for key, value in output.items():
      print('::set-output name={}::{}'.format(key, value))

if __name__ == "__main__":
    main()

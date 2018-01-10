def test_file_exists(host):
    assert host.file("/test.txt").exists

import warnings

class BuildError(Exception):
    pass

class BuildWarning(Warning):
    pass
    
def raise_msg(msg, fatal=True, category=BuildWarning):
    if isinstance(category, Warning):
        if not fatal:
            warnings.warn(msg, category)
        else:
            raise category(msg)
    else:
        raise category(msg)

def health_change(enc, cond)
  return enc[cond]["benefit"]["health"] - enc[cond]["loss"]["health"]
end

def sanity_change(enc, cond)
  return enc[cond]["benefit"]["sanity"] - enc[cond]["loss"]["sanity"]
end